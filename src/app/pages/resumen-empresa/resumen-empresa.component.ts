import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { EmpresasService } from '../../services/empresas.service';
import { ContactosEmpresaService } from '../../services/contactos_empresa.service';
import { SectoresEconomicosService } from '../../services/sectores_economicos.service';
import { TamanosEmpresaService } from '../../services/tamanos_empresa.service';
import { Empresa, ContactoEmpresa, SectorEconomico, TamanoEmpresa } from '../../models/interfaces';

interface CompanyInfo {
  razonSocial: string;
  nit: string;
  rut: string;
  cantidadEmpleados: number;
  descripcion: string;
  nacionalOInternacional: string;
  nombreComercial: string;
  direccion: string;
  ciudad: string;
  telefono: string;
  sitioWeb: string;
  sectorNombre: string;
  tamanoNombre: string;
}

interface ContactInfo {
  responsable: string;
  identificacion: string;
  cargo: string;
  celular: string;
  email: string;
  correoAlternativo: string;
}

interface Student {
  nombre: string;
  codigo: string;
  programa: string;
  semestre: string;
}

@Component({
  selector: 'app-resumen-empresa',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './resumen-empresa.component.html',
  styleUrl: './resumen-empresa.component.css'
})
export class ResumenEmpresaComponent implements OnInit {
  companyInfo: CompanyInfo = {
    razonSocial: '',
    nit: '',
    rut: '',
    cantidadEmpleados: 0,
    descripcion: '',
    nacionalOInternacional: '',
    nombreComercial: '',
    direccion: '',
    ciudad: '',
    telefono: '',
    sitioWeb: '',
    sectorNombre: '',
    tamanoNombre: ''
  };

  contactInfo: ContactInfo = {
    responsable: '',
    identificacion: '',
    cargo: '',
    celular: '',
    email: '',
    correoAlternativo: ''
  };

  empresa: Empresa | null = null;
  logoUrl: string = 'assets/logoEmpresa.png'; // Logo predeterminado
  logoBase64: string | null = null; // Logo en base64 desde la base de datos

  students: Student[] = [];
  
  isLoading = true;
  error: string | null = null;
  empresaId: number | null = null;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private empresasService: EmpresasService,
    private contactosEmpresaService: ContactosEmpresaService,
    private sectoresEconomicosService: SectoresEconomicosService,
    private tamanosEmpresaService: TamanosEmpresaService
  ) {}

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      const id = params['id'];
      if (id) {
        this.empresaId = +id;
        this.loadEmpresaData(this.empresaId);
      } else {
        this.error = 'No se especificó el ID de la empresa';
        this.isLoading = false;
      }
    });
  }

  async loadEmpresaData(empresaId: number) {
    try {
      this.isLoading = true;
      this.error = null;

      // Cargar datos en paralelo
      const [empresa, contactos, sectores, tamanos] = await Promise.all([
        this.empresasService.getById(empresaId).toPromise(),
        this.contactosEmpresaService.getAll().toPromise(),
        this.sectoresEconomicosService.getAll().toPromise(),
        this.tamanosEmpresaService.getAll().toPromise()
      ]);

      if (empresa) {
        this.empresa = empresa;
        
        // Establecer logo de la empresa: usar imagen_url_base64 si existe, sino el predeterminado
        if (empresa.imagen_url_base64 && empresa.imagen_url_base64.trim() !== '') {
          this.logoBase64 = empresa.imagen_url_base64;
          console.log('Logo cargado desde imagen_url_base64');
        } else {
          this.logoBase64 = null;
          this.logoUrl = 'assets/logoEmpresa.png';
          console.log('Usando logo predeterminado');
        }
        
        this.populateCompanyInfo(empresa, sectores || [], tamanos || []);
        this.populateContactInfo(empresa, contactos?.filter(c => c.empresa_id === empresaId) || []);
        // TODO: Cargar estudiantes asignados a esta empresa
        this.loadStudentsForCompany(empresaId);
      } else {
        this.error = 'No se encontró la empresa especificada';
      }

    } catch (error) {
      console.error('Error cargando datos de la empresa:', error);
      this.error = 'Error al cargar los datos de la empresa';
    } finally {
      this.isLoading = false;
    }
  }

  private populateCompanyInfo(empresa: Empresa, sectores: SectorEconomico[], tamanos: TamanoEmpresa[]) {
    const sector = sectores.find(s => s.sector_id === empresa.sector);
    const tamano = tamanos.find(t => t.tamano_id === empresa.tamano);

    this.companyInfo = {
      razonSocial: empresa.razon_social || '',
      nit: empresa.nit_empresa || '',
      rut: empresa.nit_empresa || '', // Usando NIT como RUT si no hay campo específico
      cantidadEmpleados: empresa.numero_empleados || 0,
      descripcion: empresa.actividad_economica || '',
      nacionalOInternacional: 'Nacional', // Valor por defecto
      nombreComercial: empresa.nombre_comercial || empresa.razon_social || '',
      direccion: empresa.direccion || '',
      ciudad: `${empresa.ciudad || ''}, ${empresa.departamento || ''}`.trim().replace(/^,|,$/, ''),
      telefono: empresa.telefono || '',
      sitioWeb: empresa.sitio_web || '',
      sectorNombre: sector?.nombre || 'N/A',
      tamanoNombre: tamano?.nombre || 'N/A'
    };
  }

  private populateContactInfo(empresa: Empresa, contactos: ContactoEmpresa[]) {
    // Priorizar información de persona de contacto de la empresa
    if (empresa.nombre_persona_contacto_empresa) {
      this.contactInfo = {
        responsable: empresa.nombre_persona_contacto_empresa || '',
        identificacion: '', // No disponible en la base de datos actual
        cargo: empresa.cargo_persona_contacto_empresa || '',
        celular: empresa.numero_persona_contacto_empresa || '',
        email: empresa.email_empresa || '',
        correoAlternativo: '' // Podríamos usar un contacto adicional si existe
      };

      // Si hay contactos adicionales, usar el email del primero como alternativo
      if (contactos.length > 0) {
        const contactoAdicional = contactos.find(c => c.es_principal) || contactos[0];
        if (contactoAdicional && contactoAdicional.email) {
          this.contactInfo.correoAlternativo = contactoAdicional.email;
        }
      }
    } else {
      // Si no hay información de contacto en la empresa, usar contactos de la tabla contactos_empresa
      const contactoPrincipal = contactos.find(c => c.es_principal) || contactos[0];
      
      if (contactoPrincipal) {
        this.contactInfo = {
          responsable: contactoPrincipal.nombre || '',
          identificacion: '', // No disponible en la base de datos actual
          cargo: contactoPrincipal.cargo || '',
          celular: contactoPrincipal.celular || contactoPrincipal.telefono || '',
          email: contactoPrincipal.email || '',
          correoAlternativo: '' // Podríamos usar un segundo contacto si existe
        };

        // Si hay más de un contacto, usar el email del segundo como alternativo
        if (contactos.length > 1) {
          const segundoContacto = contactos.find(c => c !== contactoPrincipal);
          if (segundoContacto) {
            this.contactInfo.correoAlternativo = segundoContacto.email || '';
          }
        }
      }
    }
  }

  private async loadStudentsForCompany(empresaId: number) {
    try {
      // TODO: Implementar servicio para obtener estudiantes asignados a la empresa
      // Por ahora dejamos el array vacío
      this.students = [];
    } catch (error) {
      console.error('Error cargando estudiantes:', error);
    }
  }

  goBack() {
    this.router.navigate(['/consult-empresa']);
  }
}
