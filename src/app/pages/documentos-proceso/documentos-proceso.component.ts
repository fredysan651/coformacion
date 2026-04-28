import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { DocumentosProcesoService, DocumentoProceso } from '../../services/documentos-proceso.service';
import { ProcesoCoformacionService } from '../../services/proceso_coformacion.service';
import { TiposDocumentoService } from '../../services/tipos_documento.service';
import { EstudiantesService } from '../../services/estudiantes.service';
import { ApiConfigService } from '../../services/api-config.service';
import { AuthService } from '../../services/auth.service';
import { TipoDocumento, ProcesoCoformacion, Estudiante } from '../../models/interfaces';

@Component({
  selector: 'app-documentos-proceso',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './documentos-proceso.component.html',
  styleUrl: './documentos-proceso.component.css'
})
export class DocumentosProcesoComponent implements OnInit {
  documentos: DocumentoProceso[] = [];
  tiposDocumento: TipoDocumento[] = [];
  procesoCoformacion: ProcesoCoformacion | null = null;
  estudiante: Estudiante | null = null;

  procesoId: number | null = null;
  isLoading = true;
  error: string | null = null;
  successMessage: string | null = null;
  
  showUploadModal = false;
  selectedFile: File | null = null;
  selectedTipoDoc: number | null = null;
  isUploading = false;
  uploadError: string | null = null;

  filtroEstado: string = '';
  estadosDisponibles = ['Pendiente', 'En Revisión', 'Aprobado', 'Devuelto'];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private documentosService: DocumentosProcesoService,
    private procesoService: ProcesoCoformacionService,
    private tiposDocService: TiposDocumentoService,
    private estudiantesService: EstudiantesService,
    private apiConfig: ApiConfigService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.procesoId = params['procesoId'] ? +params['procesoId'] : null;
      if (this.procesoId) {
        this.loadData();
      } else {
        this.error = 'ID de proceso no especificado';
        this.isLoading = false;
      }
    });
  }

  loadData(): void {
    if (!this.procesoId) return;

    this.isLoading = true;
    this.error = null;

    Promise.all([
      this.loadDocumentos(),
      this.loadProcesoCoformacion(),
      this.loadTiposDocumento()
    ]).catch(err => {
      this.error = 'Error al cargar los datos';
      console.error(err);
    }).finally(() => {
      this.isLoading = false;
    });
  }

  private loadDocumentos(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.procesoId) {
        reject('Proceso ID no disponible');
        return;
      }
      
      // Obtener el estudiante_id del usuario actual
      const currentUser = this.authService.getCurrentUser();
      const estudianteId = currentUser?.estudiante_id;
      
      console.log('🔍 CARGAR DOCUMENTOS:', {
        procesoId: this.procesoId,
        estudianteId,
        userType: this.authService.getUserType()
      });
      
      // Enviar estudiante_id como parámetro si es estudiante
      this.documentosService.getByProcesoId(this.procesoId, estudianteId).subscribe({
        next: (data) => {
          console.log('📄 Documentos cargados:', data.length, 'documentos');
          this.documentos = data;
          resolve();
        },
        error: (err) => {
          console.error('Error al cargar documentos:', err);
          reject(err);
        }
      });
    });
  }

  private loadProcesoCoformacion(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.procesoId) {
        reject('Proceso ID no disponible');
        return;
      }

      this.procesoService.getById(this.procesoId).subscribe({
        next: (data) => {
          this.procesoCoformacion = data;
          
          if (data.estudiante) {
            this.estudiantesService.getById(data.estudiante).subscribe({
              next: (estudiante) => {
                this.estudiante = estudiante;
              },
              error: (err) => console.error('Error al cargar estudiante:', err)
            });
          }
          resolve();
        },
        error: (err) => {
          console.error('Error al cargar proceso:', err);
          reject(err);
        }
      });
    });
  }

  private loadTiposDocumento(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.tiposDocService.getAll().subscribe({
        next: (data) => {
          this.tiposDocumento = data;
          console.log('TIPOS LOADED:', JSON.stringify(data));
          resolve();
        },
        error: (err) => {
          console.error('Error al cargar tipos de documento:', err);
          reject(err);
        }
      });
    });
  }

  openUploadModal(): void {
    this.showUploadModal = true;
    this.selectedFile = null;
    this.selectedTipoDoc = null;
    this.uploadError = null;
    console.log('MODAL ABIERTO - tiposDocumento:', JSON.stringify(this.tiposDocumento));
  }

  closeUploadModal(): void {
    this.showUploadModal = false;
    this.selectedFile = null;
    this.selectedTipoDoc = null;
    this.uploadError = null;
  }

  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      const maxSize = 10 * 1024 * 1024;
      if (file.size > maxSize) {
        this.uploadError = 'El archivo excede el tamaño maximo permitido (10 MB)';
        return;
      }
      this.selectedFile = file;
      this.uploadError = null;
      console.log('Archivo seleccionado:', file.name);
    }
  }

  uploadDocumento(): void {
    console.log('UPLOAD CLICK:', { tipoDoc: this.selectedTipoDoc, archivo: this.selectedFile?.name, proceso: this.procesoId });

    if (!this.selectedTipoDoc) {
      this.uploadError = 'Selecciona un Tipo de Documento';
      console.log('FAIL: no tipoDoc');
      return;
    }
    
    if (!this.selectedFile) {
      this.uploadError = 'Selecciona un Archivo';
      return;
    }
    
    if (!this.procesoId) {
      this.uploadError = 'Falta el ID del proceso';
      return;
    }

    this.isUploading = true;
    this.uploadError = null;

    // Use the uploadFile method from the service which handles FormData
    this.documentosService.uploadFile(
      this.selectedFile, 
      this.procesoId, 
      this.selectedTipoDoc
    ).subscribe({
      next: (response) => {
        console.log('SUCCESS:', response);
        this.documentos.push(response);
        this.successMessage = 'Documento cargado exitosamente';
        this.closeUploadModal();
        setTimeout(() => { this.successMessage = null; }, 3000);
        this.isUploading = false;
      },
      error: (err) => {
        console.error('API_ERROR:', err);
        const errorMsg = err.error?.detail || err.error?.error || err.message || 'Error al cargar documento';
        this.uploadError = errorMsg;
        this.isUploading = false;
      }
    });
  }

  getNombreTipoDocumento(tipoDocId: number): string {
    const tipo = this.tiposDocumento.find(t => t.tipo_doc_id === tipoDocId);
    return tipo?.nombre || 'Desconocido';
  }

  getColorEstado(estado: string): string {
    switch (estado) {
      case 'Pendiente':
        return '#FFA500';
      case 'En Revisión':
        return '#FFD700';
      case 'Aprobado':
        return '#32CD32';
      case 'Devuelto':
        return '#FF0000';
      default:
        return '#808080';
    }
  }

  verDocumento(documento: DocumentoProceso): void {
    if (!documento.documento_id) return;
    const downloadUrl = `${this.apiConfig.getDocumentosProcesoUrl()}${documento.documento_id}/download/`;
    window.open(downloadUrl, '_blank');
  }

  descargarDocumento(documento: DocumentoProceso): void {
    if (!documento.documento_id) return;
    const downloadUrl = `${this.apiConfig.getDocumentosProcesoUrl()}${documento.documento_id}/download/`;
    const a = document.createElement('a');
    a.href = downloadUrl;
    a.download = `documento_${documento.documento_id}`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  eliminarDocumento(documentoId: number): void {
    if (confirm('Estás seguro de que deseas eliminar este documento?')) {
      this.documentosService.delete(documentoId).subscribe({
        next: () => {
          this.documentos = this.documentos.filter(d => d.documento_id !== documentoId);
          this.successMessage = 'Documento eliminado exitosamente';
          setTimeout(() => {
            this.successMessage = null;
          }, 3000);
        },
        error: (err) => {
          console.error('Error al eliminar documento:', err);
          this.error = 'Error al eliminar el documento';
        }
      });
    }
  }

  get documentosFiltrados(): DocumentoProceso[] {
    if (!this.filtroEstado) {
      return this.documentos;
    }
    return this.documentos.filter(d => d.estado === this.filtroEstado);
  }

  get documentosPendientes(): number {
    return this.documentos.filter(d => d.estado === 'Pendiente').length;
  }

  get documentosAprobados(): number {
    return this.documentos.filter(d => d.estado === 'Aprobado').length;
  }

  get documentosDevueltos(): number {
    return this.documentos.filter(d => d.estado === 'Devuelto').length;
  }

  goBack(): void {
    if (this.estudiante) {
      this.router.navigate(['/perfil-estudiante', this.estudiante.estudiante_id]);
    }
  }
}
