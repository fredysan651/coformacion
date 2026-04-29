import { Component, OnInit } from '@angular/core';
import { environment } from '../../../environments/environment';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { EstudiantesService } from '../../services/estudiantes.service';
import { ProgramasService } from '../../services/programas.service';
import { FacultadesService } from '../../services/facultades.service';
import { PromocionesService } from '../../services/promociones.service';
import { TiposDocumentoService } from '../../services/tipos_documento.service';
import { NivelesInglesService } from '../../services/niveles_ingles.service';
import { EstadosCarteraService } from '../../services/estados_cartera.service';
import { EstudiantesEpsService } from '../../services/estudiantes_eps.service';
import { Estudiante, Programa, Facultad, Promocion, TipoDocumento, NivelIngles, EstadoCartera } from '../../models/interfaces';

@Component({
  selector: 'app-editar-estudiante',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './editar-estudiante.component.html',
  styleUrl: './editar-estudiante.component.css'
})
export class EditarEstudianteComponent implements OnInit {
  estudiante: Estudiante = {
    estudiante_id: 0,
    codigo_estudiante: '',
    nombre_completo: '',
    tipo_documento: 'CC',
    numero_documento: '',
    fecha_nacimiento: '',
    genero: 'M',
    telefono: '',
    celular: '',
    email_institucional: '',
    email_personal: '',
    direccion: '',
    ciudad: '',
    foto_url: '',
    foto: undefined,
    programa_id: 0,
    semestre: 1,
    jornada: 'Diurna',
    promedio_acumulado: null,
    estado: 'Activo',
    fecha_ingreso: '',
    fecha_creacion: '',
    fecha_actualizacion: '',
    nivel_ingles_id: null,
    estado_cartera_id: null,
    promocion_id: null,
    eps_id: null
  };

  // Datos de referencia para los dropdowns
  programas: Programa[] = [];
  facultades: Facultad[] = [];
  promociones: Promocion[] = [];
  tiposDocumento: TipoDocumento[] = [];
  nivelesIngles: NivelIngles[] = [];
  estadosCartera: EstadoCartera[] = [];
  listaEps: any[] = [];

  isLoading = true;
  isSaving = false;
  error: string | null = null;
  estudianteId: number | null = null;
  successMessage: string | null = null;

  // Para almacenar los datos originales
  originalData: Estudiante | null = null;

  // Propiedades para la foto
  fotoSeleccionada: File | null = null;
  fotoPreview: string | null = null;
  fotoError: string | null = null;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private estudiantesService: EstudiantesService,
    private programasService: ProgramasService,
    private facultadesService: FacultadesService,
    private promocionesService: PromocionesService,
    private tiposDocumentoService: TiposDocumentoService,
    private nivelesInglesService: NivelesInglesService,
    private estadosCarteraService: EstadosCarteraService,
    private estudiantesEpsService: EstudiantesEpsService
  ) {}

  ngOnInit(): void {
    // Obtener ID del estudiante de los parámetros de la ruta
    this.route.queryParams.subscribe(params => {
      if (params['id']) {
        this.estudianteId = +params['id'];
        this.loadData();
      } else {
        this.error = 'No se especificó el ID del estudiante a editar.';
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
    Promise.all([
      this.estudiantesService.getById(this.estudianteId!).toPromise(),
      this.programasService.getAll().toPromise(),
      this.facultadesService.getAll().toPromise(),
      this.promocionesService.getAll().toPromise(),
      this.tiposDocumentoService.getAll().toPromise(),
      this.nivelesInglesService.getAll().toPromise(),
      this.estadosCarteraService.getAll().toPromise(),
      this.estudiantesEpsService.getAll().toPromise()
    ]).then(([estudiante, programas, facultades, promociones, tiposDocumento, nivelesIngles, estadosCartera, listaEps]) => {
      this.estudiante = { ...estudiante };
      this.originalData = { ...estudiante };
      this.programas = programas || [];
      this.facultades = facultades || [];
      this.promociones = promociones || [];
      this.tiposDocumento = tiposDocumento || [];
      this.nivelesIngles = nivelesIngles || [];
      this.estadosCartera = estadosCartera || [];
      this.listaEps = listaEps || [];
      this.isLoading = false;
    }).catch(error => {
      console.error('Error cargando datos:', error);
      this.error = 'Error al cargar los datos del estudiante.';
      this.isLoading = false;
    });
  }

  // Métodos auxiliares para obtener nombres
  getProgramaNombre(programaId: number): string {
    const programa = this.programas.find(p => p.programa_id === programaId);
    return programa ? programa.nombre : '';
  }

  getFacultadNombre(programaId: number): string {
    const programa = this.programas.find(p => p.programa_id === programaId);
    if (programa) {
      const facultad = this.facultades.find(f => f.facultad_id === programa.facultad_id);
      return facultad ? facultad.nombre : '';
    }
    return '';
  }

  getPromocionNombre(): string {
    if (!this.estudiante.promocion_id) return 'Sin promoción asignada';
    const promocion = this.promociones.find(p => p.promocion_id === this.estudiante.promocion_id);
    return promocion ? promocion.descripcion : 'Sin promoción asignada';
  }

  getNivelInglesNombre(): string {
    if (!this.estudiante.nivel_ingles_id) return 'Sin nivel asignado';
    const nivel = this.nivelesIngles.find(n => n.nivel_id === this.estudiante.nivel_ingles_id);
    return nivel ? nivel.nombre : 'Sin nivel asignado';
  }

  getEstadoCarteraNombre(): string {
    if (!this.estudiante.estado_cartera_id) return 'Sin estado asignado';
    const estado = this.estadosCartera.find(e => e.estado_id === this.estudiante.estado_cartera_id);
    return estado ? estado.nombre : 'Sin estado asignado';
  }

  getEpsNombre(): string {
    if (!this.estudiante.eps_id) return 'Sin EPS asignada';
    const eps = this.listaEps.find(e => e.eps_id === this.estudiante.eps_id);
    return eps ? eps.nombre : 'Sin EPS asignada';
  }

  // Validación del formulario
  isValidForm(): boolean {
    return !!(
      this.estudiante.nombre_completo.trim() &&
      this.estudiante.numero_documento.trim() &&
      this.estudiante.email_institucional.trim() &&
      this.estudiante.tipo_documento
    );
  }

  hasChanges(): boolean {
    if (!this.originalData) return false;
    return JSON.stringify(this.estudiante) !== JSON.stringify(this.originalData);
  }

  // Guardar cambios (PUT)
  onSave(): void {
    if (!this.isValidForm()) {
      this.error = 'Por favor complete todos los campos obligatorios.';
      return;
    }

    this.isSaving = true;
    this.error = null;
    this.successMessage = null;

    // Preparar datos para envío - SOLO campos editables por estudiante
    const updateData: any = {
      nombre_completo: this.estudiante.nombre_completo,
      tipo_documento: this.estudiante.tipo_documento,
      numero_documento: this.estudiante.numero_documento,
      email_institucional: this.estudiante.email_institucional,
      telefono: this.estudiante.telefono?.trim() || null,
      email_personal: this.estudiante.email_personal?.trim() || null,
      celular: this.estudiante.celular,
      direccion: this.estudiante.direccion?.trim() || null,
      ciudad: this.estudiante.ciudad?.trim() || null,
      eps_id: this.estudiante.eps_id || null
    };

    this.estudiantesService.update(this.estudiante.estudiante_id, updateData).subscribe({
      next: async (response) => {
        // Subir foto si existe
        if (this.fotoSeleccionada) {
          const formData = new FormData();
          formData.append('foto', this.fotoSeleccionada);
          
          try {
            await this.estudiantesService.subirFoto(this.estudiante.estudiante_id, formData).toPromise();
            console.log('Foto subida exitosamente');
            // Limpiar la foto seleccionada
            this.fotoSeleccionada = null;
            this.fotoPreview = null;
          } catch (fotoError) {
            console.error('Error al subir la foto:', fotoError);
            // No detener el proceso aunque falle la foto
          }
        }

        this.originalData = { ...this.estudiante };
        this.successMessage = 'Información del estudiante actualizada exitosamente.';
        this.isSaving = false;
        
        // Opcional: redirigir al perfil después de 2 segundos
        setTimeout(() => {
          this.router.navigate(['/perfil-estudiante'], { 
            queryParams: { id: this.estudianteId }
          });
        }, 2000);
      },
      error: (error) => {
        console.error('Error actualizando estudiante:', error);
        this.error = 'Error al actualizar la información. Verifique los datos e intente nuevamente.';
        this.isSaving = false;
      }
    });
  }

  onCancel(): void {
    if (this.hasChanges()) {
      const confirmCancel = confirm('¿Está seguro de cancelar? Se perderán los cambios no guardados.');
      if (!confirmCancel) return;
    }
    
    this.router.navigate(['/perfil-estudiante'], { 
      queryParams: { id: this.estudianteId } 
    });
  }

  resetForm(): void {
    if (this.originalData) {
      this.estudiante = { ...this.originalData };
      this.error = null;
      this.successMessage = null;
    }
  }

  navigateToHistorialCoformacion() {
    this.router.navigate(['/historial-coformacion'], { 
      queryParams: { estudiante_id: this.estudianteId } 
    });
  }

  navigateToPerfilEstudiante() {
    this.router.navigate(['/perfil-estudiante'], { 
      queryParams: { id: this.estudianteId } 
    });
  }

  navigateToProcesoCoformacion() {
    this.router.navigate(['/proceso-coformacion'], { 
      queryParams: { estudiante_id: this.estudianteId } 
    });
  }

  refreshData() {
    this.loadData();
  }

  /**
   * Obtener la URL de la foto del estudiante
   */
  getFotoUrl(): string {
    if (this.estudiante?.foto) {
      // Si la foto es una URL completa, retornarla tal cual
      if (this.estudiante.foto.startsWith('http')) {
        return this.estudiante.foto;
      }
      // Si es una ruta relativa del servidor, agregarle el dominio base
      const baseUrl = environment.apiUrl.replace('/api', '');
      return `${baseUrl}${this.estudiante.foto}`;
    }
    // Si no hay foto, mostrar la imagen por defecto
    return 'assets/userLogo.png';
  }

  /**
   * Manejar la selección de una nueva foto
   */
  onFotoSeleccionada(event: Event): void {
    const input = event.target as HTMLInputElement;
    const files = input.files;

    if (!files || files.length === 0) {
      return;
    }

    const archivo = files[0];
    this.fotoError = null;

    // Validar tipo de archivo
    const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!tiposPermitidos.includes(archivo.type)) {
      this.fotoError = 'Formato no permitido. Use JPG, PNG, GIF o WEBP';
      return;
    }

    // Validar tamaño (máximo 5MB)
    if (archivo.size > 5 * 1024 * 1024) {
      this.fotoError = 'El archivo no debe exceder 5MB';
      return;
    }

    // Guardar archivo y crear previsualización
    this.fotoSeleccionada = archivo;

    // Crear previsualización
    const reader = new FileReader();
    reader.onload = (e: any) => {
      this.fotoPreview = e.target.result;
    };
    reader.readAsDataURL(archivo);
  }

  /**
   * Remover la foto seleccionada
   */
  removerFoto(): void {
    this.fotoSeleccionada = null;
    this.fotoPreview = null;
    this.fotoError = null;
  }
}
