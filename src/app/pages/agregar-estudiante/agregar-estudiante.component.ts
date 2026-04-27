import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { EstudiantesService } from '../../services/estudiantes.service';
import { ProgramasService } from '../../services/programas.service';
import { TiposDocumentoService } from '../../services/tipos_documento.service';
import { NivelesInglesService } from '../../services/niveles_ingles.service';
import { PromocionesService } from '../../services/promociones.service';
import { EstadosCarteraService } from '../../services/estados_cartera.service';
import { EstudiantesEpsService } from '../../services/estudiantes_eps.service';
import { Estudiante, Programa, TipoDocumento, NivelIngles, Promocion, EstadoCartera } from '../../models/interfaces';

@Component({
  selector: 'app-agregar-estudiante',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FormsModule],
  templateUrl: './agregar-estudiante.component.html',
  styleUrl: './agregar-estudiante.component.css'
})
export class AgregarEstudianteComponent implements OnInit {
  estudianteForm: FormGroup;

  // Datos para listas desplegables
  programas: Programa[] = [];
  tiposDocumento: TipoDocumento[] = [];
  nivelesIngles: NivelIngles[] = [];
  promociones: Promocion[] = [];
  estadosCartera: EstadoCartera[] = [];
  listaEps: any[] = [];
  
  // Control para nueva EPS
  mostrarNuevaEps = false;
  nuevaEpsNombre = '';
  nuevaEpsCodigo = '';

  // Opciones para campos de selección
  generoOptions = [
    { value: 'M', label: 'Masculino' },
    { value: 'F', label: 'Femenino' },
    { value: 'O', label: 'Otro' }
  ];
  jornadaOptions = [
    { value: 'Diurna', label: 'Diurna' },
    { value: 'Nocturna', label: 'Nocturna' },
    { value: 'Mixta', label: 'Mixta' }
  ];
  estadoOptions = ['Activo', 'Inactivo', 'Graduado', 'Retirado'];

  // Estados de carga
  isLoading = false;
  error: string | null = null;

  // Propiedades para la foto
  fotoSeleccionada: File | null = null;
  fotoPreview: string | null = null;
  fotoError: string | null = null;

  constructor(
    private fb: FormBuilder,
    private router: Router,
    private estudiantesService: EstudiantesService,
    private programasService: ProgramasService,
    private tiposDocumentoService: TiposDocumentoService,
    private nivelesInglesService: NivelesInglesService,
    private promocionesService: PromocionesService,
    private estadosCarteraService: EstadosCarteraService,
    private estudiantesEpsService: EstudiantesEpsService
  ) {
    this.estudianteForm = this.fb.group({
      // Información personal básica
      codigo_estudiante: ['', [Validators.required, Validators.pattern(/^\d+$/)]],
      nombres: ['', [Validators.required, Validators.minLength(3)]],
      apellidos: ['', [Validators.required, Validators.minLength(3)]],
      tipo_documento: ['CC', Validators.required],
      numero_documento: ['', [Validators.required, Validators.pattern(/^\d+$/)]],
      fecha_nacimiento: ['', Validators.required],
      genero: ['', Validators.required],

      // Información de contacto
      telefono: ['', Validators.pattern(/^\d{7,10}$/)],
      celular: ['', [Validators.required, Validators.pattern(/^\d{10}$/)]],
      email_institucional: ['', [Validators.required, Validators.email]],
      email_personal: ['', Validators.email],
      direccion: [''],
      ciudad: [''],

      // Información académica
      programa_id: [null, Validators.required],
      semestre: [1, [Validators.required, Validators.min(1), Validators.max(20)]],
      jornada: ['', Validators.required],
      promedio_acumulado: [null, [Validators.min(0), Validators.max(5)]],
      estado: ['Activo', Validators.required],
      fecha_ingreso: ['', Validators.required],

      // Información adicional
      nivel_ingles_id: [null],
      promocion_id: [null],
      estado_cartera_id: [null],
      empresa_id: [null],
      eps_id: [null],

      // Contacto de Emergencia
      contacto_emergencia: this.fb.group({
        nombres: ['', Validators.required],
        apellidos: ['', Validators.required],
        parentesco: ['', Validators.required],
        celular: ['', [Validators.required, Validators.pattern(/^\d{10}$/)]],
        telefono: ['', Validators.pattern(/^\d{7,10}$/)],
        correo: ['', Validators.email]
      })
    });
  }

  ngOnInit(): void {
    this.loadInitialData();
  }

  async loadInitialData() {
    try {
      this.isLoading = true;
      this.error = null;

      const [programas, tiposDocumento, nivelesIngles, promociones, estadosCartera, listaEps] = await Promise.all([
        this.programasService.getAll().toPromise(),
        this.tiposDocumentoService.getAll().toPromise(),
        this.nivelesInglesService.getAll().toPromise(),
        this.promocionesService.getAll().toPromise(),
        this.estadosCarteraService.getAll().toPromise(),
        this.estudiantesEpsService.getAll().toPromise()
      ]);

      this.programas = programas || [];
      this.tiposDocumento = tiposDocumento || [];
      this.nivelesIngles = nivelesIngles || [];
      this.promociones = promociones || [];
      this.estadosCartera = estadosCartera || [];
      this.listaEps = listaEps || [];

    } catch (error) {
      console.error('Error cargando datos iniciales:', error);
      this.error = 'Error al cargar los datos necesarios para el formulario';
    } finally {
      this.isLoading = false;
    }
  }

  async guardarEstudiante() {
    if (this.estudianteForm.invalid) {
      this.estudianteForm.markAllAsTouched();
      return;
    }

    try {
      this.isLoading = true;
      this.error = null;

      const formValue = this.estudianteForm.value;
      
      const estudianteData = {
        // Campos obligatorios
        codigo_estudiante: formValue.codigo_estudiante.trim(),
        nombres: formValue.nombres.trim(),
        apellidos: formValue.apellidos.trim(),
        tipo_documento: formValue.tipo_documento,
        numero_documento: formValue.numero_documento.trim(),
        fecha_nacimiento: formValue.fecha_nacimiento,
        genero: formValue.genero,
        celular: formValue.celular.trim(),
        email_institucional: formValue.email_institucional.trim(),
        programa_id: formValue.programa_id ? parseInt(formValue.programa_id) : null,
        semestre: parseInt(formValue.semestre),
        jornada: formValue.jornada,
        estado: formValue.estado,
        fecha_ingreso: formValue.fecha_ingreso,
        
        // Campos opcionales - convertir strings vacíos a null
        telefono: formValue.telefono && formValue.telefono.trim() ? formValue.telefono.trim() : null,
        email_personal: formValue.email_personal && formValue.email_personal.trim() ? formValue.email_personal.trim() : null,
        direccion: formValue.direccion && formValue.direccion.trim() ? formValue.direccion.trim() : null,
        ciudad: formValue.ciudad && formValue.ciudad.trim() ? formValue.ciudad.trim() : null,
        promedio_acumulado: formValue.promedio_acumulado ? parseFloat(formValue.promedio_acumulado) : null,
        
        // IDs opcionales
        nivel_ingles_id: formValue.nivel_ingles_id ? parseInt(formValue.nivel_ingles_id) : null,
        promocion_id: formValue.promocion_id ? parseInt(formValue.promocion_id) : null,
        estado_cartera_id: formValue.estado_cartera_id ? parseInt(formValue.estado_cartera_id) : null,
        empresa_id: formValue.empresa_id ? parseInt(formValue.empresa_id) : null,
        eps_id: formValue.eps_id ? parseInt(formValue.eps_id) : null,
        
        // Contacto de emergencia (si existe)
        contacto_emergencia_input: formValue.contacto_emergencia ? {
          nombres: formValue.contacto_emergencia.nombres.trim(),
          apellidos: formValue.contacto_emergencia.apellidos.trim(),
          parentesco: formValue.contacto_emergencia.parentesco.trim(),
          celular: formValue.contacto_emergencia.celular.trim(),
          telefono: formValue.contacto_emergencia.telefono && formValue.contacto_emergencia.telefono.trim() 
            ? formValue.contacto_emergencia.telefono.trim() 
            : null,
          correo: formValue.contacto_emergencia.correo && formValue.contacto_emergencia.correo.trim() 
            ? formValue.contacto_emergencia.correo.trim() 
            : null
        } : null
      };

      console.log('Enviando datos al servidor:', estudianteData);
      
      const response = await this.estudiantesService.create(estudianteData).toPromise() as any;
      const estudianteId = response.estudiante_id;

      // Subir foto si existe
      if (this.fotoSeleccionada) {
        const formData = new FormData();
        formData.append('foto', this.fotoSeleccionada);
        
        try {
          await this.estudiantesService.subirFoto(estudianteId, formData).toPromise();
          console.log('Foto subida exitosamente');
        } catch (fotoError) {
          console.error('Error al subir la foto:', fotoError);
          // No detener el proceso aunque falle la foto
        }
      }

      alert('Estudiante agregado exitosamente');
      this.router.navigate(['/consult-estudent']);

    } catch (error: any) {
      console.error('Error guardando estudiante:', error);
      
      // Capturar detalles de la respuesta del servidor
      let errorMessage = 'Error al guardar el estudiante. Por favor, intente nuevamente.';
      
      if (error.error) {
        console.error('Detalles del error del servidor:', error.error);
        
        // Si es un objeto con mensajes de validación
        if (typeof error.error === 'object') {
          const errorDetails = error.error;
          let details = '';
          
          // Recorrer todos los campos con error
          for (const field in errorDetails) {
            if (errorDetails.hasOwnProperty(field)) {
              const fieldError = errorDetails[field];
              const errorMsg = Array.isArray(fieldError) ? fieldError[0] : fieldError;
              console.error(`Campo "${field}":`, errorMsg);
              details += `${field}: ${errorMsg}\n`;
            }
          }
          
          if (details) {
            errorMessage = `Errores de validación:\n${details}`;
            console.error('Errores de validación completos:', details);
          }
        } else if (typeof error.error === 'string') {
          errorMessage = error.error;
        }
      }
      
      this.error = errorMessage;
    } finally {
      this.isLoading = false;
    }
  }

  cancelar() {
    if (confirm('¿Está seguro que desea cancelar? Se perderán todos los datos ingresados.')) {
      this.router.navigate(['/consult-estudent']);
    }
  }

  volverAConsultar() {
    this.router.navigate(['/consult-estudent']);
  }

  toggleNuevaEps() {
    this.mostrarNuevaEps = !this.mostrarNuevaEps;
    if (!this.mostrarNuevaEps) {
      this.nuevaEpsNombre = '';
      this.nuevaEpsCodigo = '';
    }
  }

  async agregarNuevaEps() {
    if (!this.nuevaEpsNombre.trim()) {
      alert('Por favor ingrese el nombre de la EPS');
      return;
    }

    try {
      this.isLoading = true;

      const nuevaEps = {
        nombre: this.nuevaEpsNombre.trim(),
        codigo: this.nuevaEpsCodigo.trim() || null
      };

      const epsCreada = await this.estudiantesEpsService.create(nuevaEps).toPromise();
      
      // Actualizar la lista de EPS
      this.listaEps.push(epsCreada);
      
      // Seleccionar la nueva EPS en el formulario
      this.estudianteForm.patchValue({
        eps_id: epsCreada.eps_id
      });

      // Limpiar y cerrar el formulario de nueva EPS
      this.nuevaEpsNombre = '';
      this.nuevaEpsCodigo = '';
      this.mostrarNuevaEps = false;

      alert('EPS agregada exitosamente');

    } catch (error: any) {
      console.error('Error al crear EPS:', error);
      
      if (error.status === 409) {
        // Conflicto - EPS ya existe
        alert(error.error.error || 'Ya existe una EPS con ese nombre');
        
        // Si el backend devolvió el ID de la EPS existente, seleccionarla
        if (error.error.eps_id) {
          this.estudianteForm.patchValue({
            eps_id: error.error.eps_id
          });
          this.mostrarNuevaEps = false;
        }
      } else {
        alert('Error al crear la EPS: ' + (error.error?.error || 'Error desconocido'));
      }
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * Manejar la selección de foto del estudiante
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

  get f() { return this.estudianteForm.controls; }
}
