import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { EstudiantesService } from '../../services/estudiantes.service';
import { ProgramasService } from '../../services/programas.service';
import { FacultadesService } from '../../services/facultades.service';
import { PromocionesService } from '../../services/promociones.service';
import { TiposDocumentoService } from '../../services/tipos_documento.service';
import { NivelesInglesService } from '../../services/niveles_ingles.service';
import { EstadosCarteraService } from '../../services/estados_cartera.service';
import { ProcesoCoformacionService } from '../../services/proceso_coformacion.service';
import { EmpresasService } from '../../services/empresas.service';
import { EstadoProcesoService } from '../../services/estado_proceso.service';
import { AuthService } from '../../services/auth.service';
import { Estudiante, Programa, Facultad, Promocion, TipoDocumento, NivelIngles, EstadoCartera, ProcesoCoformacion, Empresa, EstadoProceso } from '../../models/interfaces';

@Component({
  selector: 'app-perfil-estudiante',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './perfil-estudiante.component.html',
  styleUrl: './perfil-estudiante.component.css'
})
export class PerfilEstudianteComponent implements OnInit {
  estudiante: Estudiante | null = null;
  programa: Programa | null = null;
  facultad: Facultad | null = null;
  promocion: Promocion | null = null;
  tipoDocumento: TipoDocumento | null = null;
  nivelIngles: NivelIngles | null = null;
  estadoCartera: EstadoCartera | null = null;
  procesoCoformacion: ProcesoCoformacion | null = null;
  empresa: Empresa | null = null;
  estadoProceso: EstadoProceso | null = null;

  isLoading = true;
  error: string | null = null;
  estudianteId: number | null = null;
  isCoformador: boolean = false;

  // Propiedades para la carga de foto
  isLoadingFoto = false;
  mensajeFoto: string | null = null;
  tipoMensajeFoto: 'exito' | 'error' | 'info' = 'info';

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
    private procesoCoformacionService: ProcesoCoformacionService,
    private empresasService: EmpresasService,
    private estadoProcesoService: EstadoProcesoService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    // Verificar si el usuario es coformador
    this.isCoformador = this.authService.isCoformacion();

    // Obtener ID del estudiante de los parámetros de la ruta
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.estudianteId = +params['id'];
        this.loadStudentProfile();
      } else {
        // Si no hay ID en params, revisar queryParams (para compatibilidad)
        this.route.queryParams.subscribe(queryParams => {
          if (queryParams['id']) {
            this.estudianteId = +queryParams['id'];
            this.loadStudentProfile();
          } else {
            // Intentar obtener el ID de la sesión actual
            const sessionStudentId = this.getSessionStudentId();
            if (sessionStudentId) {
              this.estudianteId = sessionStudentId;
              this.loadStudentProfile();
            } else {
              // Si no hay ID, podríamos mostrar el primer estudiante o redirigir
              this.loadFirstStudent();
            }
          }
        });
      }
    });
  }

  private getSessionStudentId(): number | null {
    // Intentar obtener del AuthService
    const currentUser = this.authService.getCurrentUser();
    if (currentUser && currentUser.estudiante_id) {
      return +currentUser.estudiante_id;
    }

    // Intentar obtener del sessionStorage (fallback)
    const storedId = sessionStorage.getItem('estudiante_id');
    if (storedId) {
      return +storedId;
    }

    return null;
  }

  private loadFirstStudent(): void {
    // Solo cargar el primer estudiante si no estamos autenticados como estudiante
    // Si estamos autenticados como estudiante pero no encontramos el ID, es un error
    if (this.authService.isEstudiante()) {
      this.error = 'No se pudo identificar al estudiante. Por favor inicie sesión nuevamente.';
      this.isLoading = false;
      return;
    }

    this.estudiantesService.getAll().subscribe({
      next: (estudiantes) => {
        if (estudiantes && estudiantes.length > 0) {
          this.estudianteId = estudiantes[0].estudiante_id;
          this.loadStudentProfile();
        } else {
          this.error = 'No hay estudiantes registrados en el sistema.';
          this.isLoading = false;
        }
      },
      error: (error) => {
        console.error('Error cargando estudiantes:', error);
        this.error = 'Error al cargar los estudiantes.';
        this.isLoading = false;
      }
    });
  }

  private loadStudentProfile(): void {
    if (!this.estudianteId) return;

    this.isLoading = true;
    this.error = null;

    // Cargar datos del estudiante
    this.estudiantesService.getById(this.estudianteId).subscribe({
      next: (estudiante) => {
        this.estudiante = estudiante;
        this.loadRelatedData();
      },
      error: (error) => {
        console.error('Error cargando estudiante:', error);
        this.error = 'Error al cargar la información del estudiante.';
        this.isLoading = false;
      }
    });
  }

  private loadRelatedData(): void {
    if (!this.estudiante) return;

    const requests = [];

    // Cargar datos relacionados
    if (this.estudiante.programa_id) {
      requests.push(
        this.programasService.getById(this.estudiante.programa_id).subscribe({
          next: (programa) => {
            this.programa = programa;
            // Cargar facultad
            if (programa.facultad_id) {
              this.facultadesService.getById(programa.facultad_id).subscribe({
                next: (facultad) => this.facultad = facultad,
                error: (error) => console.error('Error cargando facultad:', error)
              });
            }
          },
          error: (error) => console.error('Error cargando programa:', error)
        })
      );
    }

    // Para tipo_documento, ahora es un ENUM (string), no necesita consulta adicional

    if (this.estudiante.promocion_id) {
      requests.push(
        this.promocionesService.getById(this.estudiante.promocion_id).subscribe({
          next: (promocion) => this.promocion = promocion,
          error: (error) => console.error('Error cargando promoción:', error)
        })
      );
    }

    if (this.estudiante.nivel_ingles_id) {
      requests.push(
        this.nivelesInglesService.getById(this.estudiante.nivel_ingles_id).subscribe({
          next: (nivel) => this.nivelIngles = nivel,
          error: (error) => console.error('Error cargando nivel inglés:', error)
        })
      );
    }

    if (this.estudiante.estado_cartera_id) {
      requests.push(
        this.estadosCarteraService.getById(this.estudiante.estado_cartera_id).subscribe({
          next: (estado) => this.estadoCartera = estado,
          error: (error) => console.error('Error cargando estado cartera:', error)
        })
      );
    }

    // Cargar proceso de coformación activo solo si es coformador
    if (this.isCoformador) {
      this.procesoCoformacionService.getAll().subscribe({
        next: (procesos) => {
          const procesoActivo = procesos.find(p => p.estudiante === this.estudiante!.estudiante_id);
          if (procesoActivo) {
            this.procesoCoformacion = procesoActivo;

            // Cargar empresa del proceso
            if (procesoActivo.empresa) {
              this.empresasService.getById(procesoActivo.empresa).subscribe({
                next: (empresa) => this.empresa = empresa,
                error: (error) => console.error('Error cargando empresa:', error)
              });
            }

            // Cargar estado del proceso
            if (procesoActivo.estado) {
              this.estadoProcesoService.getById(procesoActivo.estado).subscribe({
                next: (estado) => this.estadoProceso = estado,
                error: (error) => console.error('Error cargando estado proceso:', error)
              });
            }
          }
          this.isLoading = false;
        },
        error: (error) => {
          console.error('Error cargando procesos:', error);
          this.isLoading = false;
        }
      });
    } else {
      // Si es estudiante, solo terminar la carga sin cargar procesos
      this.isLoading = false;
    }
  }

  // Métodos auxiliares para mostrar información
  getNombreCompleto(): string {
    return this.estudiante ? this.estudiante.nombre_completo : '';
  }

  getTipoDocumentoNombre(): string {
    // Ahora tipo_documento es un ENUM string, no necesita consulta
    if (!this.estudiante?.tipo_documento) return 'N/A';

    const tiposMap: { [key: string]: string } = {
      'CC': 'Cédula de Ciudadanía',
      'CE': 'Cédula de Extranjería',
      'PAS': 'Pasaporte',
      'TI': 'Tarjeta de Identidad'
    };

    return tiposMap[this.estudiante.tipo_documento] || this.estudiante.tipo_documento;
  }

  getProgramaNombre(): string {
    return this.programa ? this.programa.nombre : 'N/A';
  }

  getFacultadNombre(): string {
    return this.facultad ? this.facultad.nombre : 'N/A';
  }

  getPromocionNombre(): string {
    return this.promocion ? this.promocion.descripcion : 'N/A';
  }

  getNivelInglesNombre(): string {
    return this.nivelIngles ? this.nivelIngles.nombre : 'N/A';
  }

  getEstadoCarteraNombre(): string {
    return this.estadoCartera ? this.estadoCartera.nombre : 'N/A';
  }

  getEmpresaNombre(): string {
    return this.empresa && this.empresa.nombre_comercial ? this.empresa.nombre_comercial : 'Sin empresa';
  }

  getEstadoProcesoNombre(): string {
    return this.estadoProceso ? this.estadoProceso.nombre : 'N/A';
  }

  getFechaInicioFormateada(): string {
    return this.procesoCoformacion ? this.procesoCoformacion.fecha_inicio : 'N/A';
  }

  getFechaFinFormateada(): string {
    return this.procesoCoformacion?.fecha_fin || 'En curso';
  }

  // Navegación
  navigateToHistorialCoformacion() {
    this.router.navigate(['/historial-coformacion'], {
      queryParams: { estudiante_id: this.estudianteId }
    });
  }

  navigateToEditarEstudiante() {
    this.router.navigate(['/editar-estudiante'], {
      queryParams: { id: this.estudianteId }
    });
  }

  navigateToCreateProcess() {
    this.router.navigate(['/proceso-coformacion'], {
      queryParams: { estudiante_id: this.estudianteId }
    });
  }

  navigateToEditProcess() {
    if (this.procesoCoformacion && this.procesoCoformacion.proceso_id) {
      this.router.navigate(['/proceso-coformacion'], {
        queryParams: { 
          id: this.procesoCoformacion.proceso_id,
          estudiante_id: this.estudianteId 
        }
      });
    }
  }

  refreshData() {
    this.loadStudentProfile();
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
      // Si es una ruta relativa del servidor, agregarle el dominio
      return `http://127.0.0.1:8001${this.estudiante.foto}`;
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

    // Validar tipo de archivo
    const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!tiposPermitidos.includes(archivo.type)) {
      this.mostrarMensaje('error', 'Formato de archivo no permitido. Use JPG, PNG, GIF o WEBP');
      return;
    }

    // Validar tamaño (máximo 5MB)
    if (archivo.size > 5 * 1024 * 1024) {
      this.mostrarMensaje('error', 'El archivo no debe exceder 5MB');
      return;
    }

    this.cargarFoto(archivo);
  }

  /**
   * Cargar la foto al servidor
   */
  private cargarFoto(archivo: File): void {
    if (!this.estudiante || !this.estudiantesService) {
      return;
    }

    this.isLoadingFoto = true;
    this.mensajeFoto = null;

    const formData = new FormData();
    formData.append('foto', archivo);

    // Llamar al endpoint de carga de foto
    this.estudiantesService.subirFoto(this.estudiante.estudiante_id, formData).subscribe({
      next: (response: any) => {
        this.isLoadingFoto = false;
        
        // Actualizar la data del estudiante con la nueva foto
        if (response.estudiante) {
          this.estudiante = response.estudiante;
        }
        
        this.mostrarMensaje('exito', 'Foto actualizada correctamente');
        
        // Limpiar el mensaje después de 5 segundos
        setTimeout(() => {
          this.mensajeFoto = null;
        }, 5000);
      },
      error: (error: any) => {
        this.isLoadingFoto = false;
        const mensaje = error?.error?.error || 'Error al cargar la foto';
        this.mostrarMensaje('error', mensaje);
        console.error('Error cargando foto:', error);
      }
    });
  }

  /**
   * Mostrar un mensaje al usuario
   */
  private mostrarMensaje(tipo: 'exito' | 'error' | 'info', mensaje: string): void {
    this.tipoMensajeFoto = tipo;
    this.mensajeFoto = mensaje;
  }
}

