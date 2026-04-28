import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { EmpresasService } from '../../services/empresas.service';
import { SectoresEconomicosService } from '../../services/sectores_economicos.service';
import { TamanosEmpresaService } from '../../services/tamanos_empresa.service';
import { ContactosEmpresaService } from '../../services/contactos_empresa.service';
import { TiposContactoService } from '../../services/tipos_contacto.service';
import { AuthService } from '../../services/auth.service';
import { Empresa, SectorEconomico, TamanoEmpresa, ContactoEmpresa, TipoContacto, EstadoConvenio } from '../../models/interfaces';

interface CompanyForm {
  nombre: string;
  razonSocial: string;
  nit: string;
  ccb: string;
  actividadEconomica: string;
  pais: string;
  sector: string;
  direccion: string;
  localidad: string;
  tamanoEmpresa: string;
  formatoRegistro: string;
  estado: string;
  ccRepresentanteLegal: string;
  ejecutivoCuenta: string;
  paginaWeb: string;
  rut: string;
  ciio: string;
}

interface Agreement {
  tipoConvenio: string;
  fechaConvenio: string;
  duracionConvenio: string;
}

interface Program {
  nombre: string;
  cupos: number;
}

@Component({
  selector: 'app-editar-empresa',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './editar-empresa.component.html',
  styleUrl: './editar-empresa.component.css'
})
export class EditarEmpresaComponent implements OnInit {
  empresa: Empresa = {
    empresa_id: 0,
    razon_social: '',
    nombre_comercial: '',
    sector: 0,
    tamano: 0,
    direccion: '',
    ciudad: '',
    departamento: '',
    telefono: '',
    email_empresa: '',
    sitio_web: '',
    cuota_sena: null,
    numero_empleados: null,
    nombre_persona_contacto_empresa: '',
    numero_persona_contacto_empresa: '',
    cargo_persona_contacto_empresa: '',
    estado_convenio: EstadoConvenio.EnTramite,
    fecha_convenio: '',
    convenio_url: '',
    actividad_economica: '',
    horario_laboral: '',
    trabaja_sabado: false,
    observaciones: '',
    estado: true,
    fecha_creacion: '',
    fecha_actualizacion: '',
    nit_empresa: ''
  };
  
  // Campos adicionales para el formulario
  nacionalOInternacional: string = 'Nacional';
  identificacion_contacto: string = '';
  correo_alternativo: string = '';

  // Contacto principal de la empresa
  contactoPrincipal: ContactoEmpresa = {
    contacto_id: 0,
    empresa_id: 0,
    nombre: '',
    cargo: '',
    area: '',
    telefono: '',
    celular: '',
    email: '',
    tipo: '',
    es_principal: false,
    estado: true,
    fecha_creacion: '',
    fecha_actualizacion: ''
  };

  // Datos de referencia para los dropdowns
  sectoresEconomicos: SectorEconomico[] = [];
  tamanosEmpresa: TamanoEmpresa[] = [];
  tiposContacto: TipoContacto[] = [];

  isLoading = true;
  isSaving = false;
  error: string | null = null;
  empresaId: number | null = null;
  successMessage: string | null = null;

  // Para almacenar los datos originales
  originalEmpresaData: Empresa | null = null;
  originalContactoData: ContactoEmpresa | null = null;

  // Estados del formulario
  showContactForm = false;
  isEditingContact = false;
  
  // Logo/Imagen de la empresa
  logoEmpresa: File | null = null;
  nombreLogoEmpresa: string = '';
  logoPreview: string | null = null;
  imagenBase64: string | null = null; // Para guardar la imagen en base64

  companyForm: CompanyForm = {
    nombre: 'Empresa de Ejemplo',
    razonSocial: 'Empresa de Ejemplo S.A.S',
    nit: '900.123.456-7',
    ccb: '',
    ciio: '',
    actividadEconomica: 'Desarrollo de Software',
    pais: 'Colombia',
    sector: 'Tecnología',
    direccion: 'Calle 123 # 45-67',
    localidad: 'Chapinero',
    tamanoEmpresa: 'Mediana',
    formatoRegistro: '',
    estado: 'Activo',
    ccRepresentanteLegal: '12345678',
    ejecutivoCuenta: 'Juan Pérez',
    paginaWeb: 'www.empresaejemplo.com',
    rut: '900123456-7'
  };

  // Archivo seleccionado para cada campo
  selectedFiles = {
    formatoRegistro: null as File | null,
    ccb: null as File | null,
    ciio: null as File | null
  };

  // Nombres de archivos para mostrar
  fileNames = {
    formatoRegistro: 'formato_actual.pdf',
    ccb: 'ccb_actual.pdf',
    ciio: 'ciio_actual.pdf'
  };

  agreement: Agreement = {
    tipoConvenio: 'Prácticas Profesionales',
    fechaConvenio: '2024-02-20',
    duracionConvenio: '180'
  };

  availablePrograms: Program[] = [
    { nombre: 'Ingeniería de Software', cupos: 3 },
    { nombre: 'Ingeniería Industrial', cupos: 2 },
    { nombre: 'Marketing y Logística', cupos: 1 },
    { nombre: 'Administración de Empresas', cupos: 2 },
    { nombre: 'Diseño de Producto', cupos: 0 },
    { nombre: 'Negocios Internacionales', cupos: 1 },
    { nombre: 'Comercio y Negocios Exterior', cupos: 0 },
    { nombre: 'Gestión de Puertos y Personas Internacionales', cupos: 1 }
  ];

  observaciones: string = 'Empresa con convenio activo desde 2023. Buena experiencia con practicantes anteriores.';
  profileImage: string | null = 'assets/empresa-ejemplo.png';

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private empresasService: EmpresasService,
    private sectoresEconomicosService: SectoresEconomicosService,
    private tamanosEmpresaService: TamanosEmpresaService,
    private contactosEmpresaService: ContactosEmpresaService,
    private tiposContactoService: TiposContactoService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    // Obtener ID de la empresa de los parámetros de la ruta
    this.route.queryParams.subscribe(params => {
      if (params['id']) {
        this.empresaId = +params['id'];
        this.loadData();
      } else {
        this.error = 'No se especificó el ID de la empresa a editar.';
        this.isLoading = false;
      }
    });

    // Mostrar mensaje de éxito si viene en los parámetros
    if (this.route.snapshot.queryParams['mensaje']) {
      this.successMessage = this.route.snapshot.queryParams['mensaje'];
      setTimeout(() => this.successMessage = null, 5000);
    }
  }

  private loadData(): void {
    this.isLoading = true;
    this.error = null;

    // Cargar todos los datos necesarios
    // Hacer tiposContacto opcional para que no falle si el servicio no está disponible
    Promise.all([
      this.empresasService.getById(this.empresaId!).toPromise(),
      this.sectoresEconomicosService.getAll().toPromise(),
      this.tamanosEmpresaService.getAll().toPromise(),
      this.tiposContactoService.getAll().toPromise().catch(() => []), // Si falla, usar array vacío
      this.contactosEmpresaService.getAll().toPromise()
    ]).then(([empresa, sectores, tamanos, tiposContacto, contactos]) => {
      if (!empresa) {
        throw new Error('No se encontró la empresa');
      }
      
      // Asegurar que logo_url no cause problemas si viene en la respuesta
      if (empresa && 'logo_url' in empresa) {
        delete empresa.logo_url;
      }
      
      this.empresa = { ...empresa };
      this.originalEmpresaData = { ...empresa };
      this.sectoresEconomicos = sectores || [];
      this.tamanosEmpresa = tamanos || [];
      this.tiposContacto = tiposContacto || [];
      
      // Cargar imagen base64 si existe
      if (empresa.imagen_url_base64) {
        this.imagenBase64 = empresa.imagen_url_base64;
        this.logoPreview = empresa.imagen_url_base64;
      }
      
      // Inicializar campos adicionales
      this.nacionalOInternacional = 'Nacional'; // Valor por defecto
      this.identificacion_contacto = ''; // No disponible en el modelo actual
      this.correo_alternativo = ''; // Se puede obtener de contactos adicionales si existe

      // Buscar contacto principal de la empresa
      const contactosEmpresa = contactos?.filter(c => c.empresa_id === this.empresa.empresa_id) || [];
      if (contactosEmpresa.length > 0) {
        this.contactoPrincipal = { ...contactosEmpresa[0] };
        this.originalContactoData = { ...contactosEmpresa[0] };
        this.isEditingContact = true;
        
        // Si hay más de un contacto, usar el email del segundo como alternativo
        if (contactosEmpresa.length > 1) {
          const segundoContacto = contactosEmpresa.find(c => c !== this.contactoPrincipal);
          if (segundoContacto && segundoContacto.email) {
            this.correo_alternativo = segundoContacto.email;
          }
        }
      } else {
        // Si no hay contacto, preparar uno nuevo
        this.contactoPrincipal.empresa_id = this.empresa.empresa_id;
        this.isEditingContact = false;
      }

      this.isLoading = false;
    }).catch(error => {
      console.error('Error cargando datos:', error);
      const errorMessage = error?.error?.error || error?.error?.message || error?.message || 'Error desconocido';
      this.error = `Error al cargar los datos de la empresa: ${errorMessage}`;
      this.isLoading = false;
    });
  }

  // Métodos auxiliares para obtener nombres
  getSectorNombre(sectorId: number | null | undefined): string {
    if (!sectorId) return 'Sin sector';
    const sector = this.sectoresEconomicos.find(s => s.sector_id === sectorId);
    return sector ? sector.nombre : 'Sin sector';
  }

  getTamanoDescripcion(tamanoId: number | null | undefined): string {
    if (!tamanoId) return 'Sin tamaño';
    const tamano = this.tamanosEmpresa.find(t => t.tamano_id === tamanoId);
    return tamano ? tamano.nombre : 'Sin tamaño';
  }

  // Validación del formulario
  isValidEmpresaForm(): boolean {
    return !!(
      (this.empresa.razon_social || '').trim() &&
      (this.empresa.nit_empresa || '').trim() &&
      this.empresa.sector &&
      this.empresa.tamano &&
      (this.empresa.direccion || '').trim() &&
      (this.empresa.ciudad || '').trim() &&
      (this.empresa.departamento || '').trim() &&
      (this.empresa.actividad_economica || '').trim() &&
      (this.empresa.nombre_persona_contacto_empresa || '').trim() &&
      (this.empresa.cargo_persona_contacto_empresa || '').trim() &&
      (this.empresa.email_empresa || '').trim()
    );
  }

  isValidContactoForm(): boolean {
    return !!(
      this.contactoPrincipal.nombre.trim() &&
      this.contactoPrincipal.email.trim()
    );
  }

  hasEmpresaChanges(): boolean {
    if (!this.originalEmpresaData) return false;
    return JSON.stringify(this.empresa) !== JSON.stringify(this.originalEmpresaData);
  }

  hasContactoChanges(): boolean {
    if (!this.originalContactoData) return true; // Nuevo contacto
    return JSON.stringify(this.contactoPrincipal) !== JSON.stringify(this.originalContactoData);
  }

  hasAnyChanges(): boolean {
    return this.hasEmpresaChanges() || this.hasContactoChanges();
  }

  // Guardar cambios (PUT)
  async guardarCambios(): Promise<void> {
    if (!this.isValidEmpresaForm()) {
      this.error = 'Por favor complete todos los campos obligatorios de la empresa.';
      return;
    }

    this.isSaving = true;
    this.error = null;
    this.successMessage = null;

    try {
      // Preparar datos de la empresa para actualizar
      const empresaData: any = {
        razon_social: this.empresa.razon_social,
        nombre_comercial: this.empresa.nombre_comercial || '',
        nit_empresa: this.empresa.nit_empresa,
        sector: this.empresa.sector ? parseInt(String(this.empresa.sector)) : null,
        tamano: this.empresa.tamano ? parseInt(String(this.empresa.tamano)) : null,
        direccion: this.empresa.direccion,
        ciudad: this.empresa.ciudad,
        departamento: this.empresa.departamento,
        telefono: this.empresa.telefono || '',
        email_empresa: this.empresa.email_empresa || '',
        sitio_web: this.empresa.sitio_web || '',
        numero_empleados: this.empresa.numero_empleados || null,
        actividad_economica: this.empresa.actividad_economica,
        nombre_persona_contacto_empresa: this.empresa.nombre_persona_contacto_empresa,
        numero_persona_contacto_empresa: this.empresa.numero_persona_contacto_empresa || '',
        cargo_persona_contacto_empresa: this.empresa.cargo_persona_contacto_empresa,
        estado_convenio: this.empresa.estado_convenio,
        fecha_convenio: this.empresa.fecha_convenio || null,
        convenio_url: this.empresa.convenio_url || '',
        horario_laboral: this.empresa.horario_laboral || '',
        trabaja_sabado: this.empresa.trabaja_sabado || false,
        observaciones: this.empresa.observaciones || '',
        estado: this.empresa.estado !== false,
        cuota_sena: this.empresa.cuota_sena || null,
        imagen_url_base64: this.imagenBase64 || this.empresa.imagen_url_base64 || null  // Guardar la imagen en base64
      };

      // Actualizar empresa
      const empresaResponse = await this.empresasService.update(this.empresa.empresa_id, empresaData).toPromise();
      this.originalEmpresaData = { ...this.empresa };

      this.successMessage = 'Información de la empresa actualizada exitosamente.';
      this.isSaving = false;
      
      // Redirigir según el rol del usuario
      setTimeout(() => {
        // Obtener el tipo de usuario desde el servicio de autenticación
        const userType = this.authService.getUserType();
        
        if (userType === 'coformacion') {
          // Si es coformación, redirigir a consult-empresa
          this.router.navigate(['/consult-empresa']);
        } else if (userType === 'empresa') {
          // Si es empresa, redirigir a su página de información
          this.router.navigate(['/informacion-empresa'], { 
            queryParams: { id: this.empresaId }
          });
        } else {
          // Por defecto, redirigir a resumen-empresa
          this.router.navigate(['/resumen-empresa'], { 
            queryParams: { id: this.empresaId }
          });
        }
      }, 2000);

    } catch (error) {
      console.error('Error actualizando empresa:', error);
      this.error = 'Error al actualizar la información. Verifique los datos e intente nuevamente.';
      this.isSaving = false;
    }
  }

  cancelar(): void {
    if (this.hasAnyChanges()) {
      const confirmCancel = confirm('¿Está seguro de cancelar? Se perderán los cambios no guardados.');
      if (!confirmCancel) return;
    }
    
    // Redirigir según el rol del usuario
    const userType = this.authService.getUserType();
    
    if (userType === 'coformacion') {
      // Si es coformación, redirigir a consult-empresa
      this.router.navigate(['/consult-empresa']);
    } else if (userType === 'empresa') {
      // Si es empresa, redirigir a su página de información
      this.router.navigate(['/informacion-empresa'], { 
        queryParams: { id: this.empresaId } 
      });
    } else {
      // Por defecto, redirigir a consult-empresa
      this.router.navigate(['/consult-empresa']);
    }
  }

  resetForm(): void {
    if (this.originalEmpresaData) {
      this.empresa = { ...this.originalEmpresaData };
    }
    
    if (this.originalContactoData) {
      this.contactoPrincipal = { ...this.originalContactoData };
    } else {
      // Reset contacto nuevo
      this.contactoPrincipal = {
        contacto_id: 0,
        empresa_id: this.empresa.empresa_id,
        nombre: '',
        cargo: '',
        area: '',
        telefono: '',
        celular: '',
        email: '',
        tipo: '',
        es_principal: false,
        estado: true,
        fecha_creacion: '',
        fecha_actualizacion: ''
      };
    }
    
    this.error = null;
    this.successMessage = null;
  }

  toggleContactForm(): void {
    this.showContactForm = !this.showContactForm;
  }

  navigateToInformacionEmpresa(): void {
    this.router.navigate(['/informacion-empresa'], { 
      queryParams: { id: this.empresaId } 
    });
  }

  navigateToPublicarOferta(): void {
    this.router.navigate(['/publicar-oferta'], { 
      queryParams: { empresa_id: this.empresaId } 
    });
  }

  refreshData(): void {
    this.loadData();
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.profileImage = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  // Métodos para manejar el logo de la empresa
  onLogoSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      
      // Validar que sea una imagen
      if (!file.type.startsWith('image/')) {
        alert('Por favor, seleccione un archivo de imagen válido.');
        return;
      }
      
      // Validar tamaño del archivo (máximo 5MB)
      const maxSize = 5 * 1024 * 1024; // 5MB
      if (file.size > maxSize) {
        alert('El tamaño del archivo no debe exceder 5MB. Por favor, seleccione una imagen más pequeña.');
        return;
      }
      
      this.logoEmpresa = file;
      this.nombreLogoEmpresa = file.name;
      
      // Crear preview y convertir a base64
      const reader = new FileReader();
      reader.onload = (e: any) => {
        const base64String = e.target.result;
        this.logoPreview = base64String; // Para el preview
        this.imagenBase64 = base64String; // Guardamos el base64 completo con prefijo
        console.log('Imagen convertida a base64. Tamaño:', base64String.length, 'caracteres');
      };
      reader.onerror = () => {
        alert('Error al leer el archivo. Por favor, intente nuevamente.');
        this.logoEmpresa = null;
        this.nombreLogoEmpresa = '';
        this.logoPreview = null;
        this.imagenBase64 = null;
      };
      reader.readAsDataURL(file);
    }
  }

  triggerLogoInput(): void {
    const logoInput = document.getElementById('logoInputEdit') as HTMLInputElement;
    if (logoInput) {
      logoInput.click();
    }
  }

  onDocumentSelected(event: any, fieldName: 'formatoRegistro' | 'ccb' | 'ciio') {
    const file = event.target.files[0];
    if (file) {
      this.selectedFiles[fieldName] = file;
      this.fileNames[fieldName] = file.name;
      this.companyForm[fieldName] = file.name;
    }
  }

  getTotalCupos(): number {
    return this.availablePrograms.reduce((total, program) => total + program.cupos, 0);
  }
}
