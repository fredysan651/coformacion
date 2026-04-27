import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { ProcesoCoformacionService } from '../../services/proceso_coformacion.service';
import { EstudiantesService } from '../../services/estudiantes.service';
import { EmpresasService } from '../../services/empresas.service';
import { EstadoProcesoService } from '../../services/estado_proceso.service';
import { AuthService } from '../../services/auth.service';
import { ProcesoCoformacion, Estudiante, Empresa, EstadoProceso } from '../../models/interfaces';

interface ProcesoHistorial extends ProcesoCoformacion {
  estudiante_nombre?: string;
  empresa_nombre?: string;
  estado_nombre?: string;
}

@Component({
  selector: 'app-historial-coformacion',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './historial-coformacion.component.html',
  styleUrl: './historial-coformacion.component.css'
})
export class HistorialCoformacionComponent implements OnInit {
  procesos: ProcesoHistorial[] = [];
  isLoading = true;
  error: string | null = null;
  userType: string | null = null;
  currentStudentId: number | null = null;
  vieneDelFormulario = false;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private procesoCoformacionService: ProcesoCoformacionService,
    private estudiantesService: EstudiantesService,
    private empresasService: EmpresasService,
    private estadoProcesoService: EstadoProcesoService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.userType = this.authService.getUserType();
    
    // Obtener el ID del estudiante de los parámetros si existe
    this.route.queryParams.subscribe(params => {
      console.log('QueryParams recibidos:', params);
      if (params['estudiante_id']) {
        this.currentStudentId = +params['estudiante_id'];
        console.log('CurrentStudentId establecido a:', this.currentStudentId);
      } else {
        // Si no está en parámetros, obtener del sessionStorage (del login directo)
        const storedId = sessionStorage.getItem('estudiante_id');
        if (storedId) {
          this.currentStudentId = +storedId;
          console.log('CurrentStudentId obtenido del sessionStorage:', this.currentStudentId);
        }
        // También intentar obtener del AuthService
        const currentUser = this.authService.getCurrentUser();
        if (!this.currentStudentId && currentUser?.estudiante_id) {
          this.currentStudentId = currentUser.estudiante_id;
          console.log('CurrentStudentId obtenido del AuthService:', this.currentStudentId);
        }
      }
      // Detectar si viene del formulario (cuando hay estudiante_id en params)
      this.vieneDelFormulario = !!params['estudiante_id'];
      console.log('VieneDelFormulario:', this.vieneDelFormulario);
      
      // Cargar procesos cuando ya tenemos los parámetros
      this.loadProcesos();
    });
  }

  loadProcesos(): void {
    this.isLoading = true;
    this.error = null;

    // Cargar todos los procesos y datos necesarios
    Promise.all([
      this.procesoCoformacionService.getAll(this.currentStudentId || undefined).toPromise().catch(err => {
        console.error('Error cargando procesos:', err);
        return [];
      }),
      this.estudiantesService.getAll().toPromise().catch(err => {
        console.error('Error cargando estudiantes:', err);
        return [];
      }),
      this.empresasService.getAll().toPromise().catch(err => {
        console.error('Error cargando empresas:', err);
        return [];
      }),
      this.estadoProcesoService.getAll().toPromise().catch(err => {
        console.error('Error cargando estados:', err);
        return [];
      })
    ]).then(([procesos, estudiantes, empresas, estados]) => {
      const procesosData = procesos || [];
      const estudiantesData = estudiantes || [];
      const empresasData = empresas || [];
      const estadosData = estados || [];

      // Enriquecer procesos con nombres
      this.procesos = procesosData.map((proceso: ProcesoCoformacion) => {
        const estudiante = estudiantesData.find(e => e.estudiante_id === proceso.estudiante);
        const empresa = empresasData.find(e => e.empresa_id === proceso.empresa);
        const estado = estadosData.find(e => e.estado_id === proceso.estado);

        return {
          ...proceso,
          estudiante_nombre: estudiante ? estudiante.nombre_completo : 'Desconocido',
          empresa_nombre: empresa ? empresa.nombre_comercial : 'Desconocida',
          estado_nombre: estado ? estado.nombre : 'Desconocido'
        } as ProcesoHistorial;
      });

      // Filtrar procesos del estudiante actual si tenemos un ID
      if (this.currentStudentId) {
        this.procesos = this.procesos.filter(p => p.estudiante === this.currentStudentId);
      } else if (this.userType === 'coformacion' && this.currentStudentId) {
        // Fallback para coformadores sin parámetro
        this.procesos = this.procesos.filter(p => p.estudiante === this.currentStudentId);
      }

      this.isLoading = false;
    }).catch(error => {
      console.error('Error cargando historial:', error);
      this.error = 'Error al cargar el historial de procesos. Verifica que el backend esté ejecutándose.';
      this.isLoading = false;
    });
  }

  editarProceso(procesoId: number): void {
    if (this.procesos.length > 0) {
      const proceso = this.procesos.find(p => p.proceso_id === procesoId);
      if (proceso) {
        this.router.navigate(['/proceso-coformacion'], {
          queryParams: {
            id: procesoId,
            estudiante_id: proceso.estudiante
          }
        });
      }
    }
  }

  volverAlPerfil(): void {
    if (this.currentStudentId) {
      this.router.navigate(['/perfil-estudiante'], {
        queryParams: { id: this.currentStudentId }
      });
    } else {
      this.router.navigate(['/inicio']);
    }
  }

  volverAlFormulario(): void {
    if (this.currentStudentId) {
      this.router.navigate(['/proceso-coformacion'], {
        queryParams: { estudiante_id: this.currentStudentId }
      });
    }
  }

  refreshData(): void {
    this.loadProcesos();
  }
}
