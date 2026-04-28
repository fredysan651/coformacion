export interface TipoDocumento {
  tipo_doc_id: number;
  nombre: string;
}

export interface Facultad {
  facultad_id: number;
  nombre: string;
  estado: boolean;
  fecha_creacion: string;
}

export interface Programa {
  programa_id: number;
  codigo: string;
  nombre: string;
  facultad_id: number;
  duracion_semestres: number;
  modalidad: string;
  nivel: string;
  resolucion_registro?: string;
  fecha_resolucion?: string;
  estado: boolean;
  fecha_creacion: string;
  fecha_actualizacion: string;
}

export interface NivelIngles {
  nivel_id: number;
  nombre: string;
}

export interface Promocion {
  promocion_id: number;
  descripcion: string;
}

export interface EstadoCartera {
  estado_id: number;
  nombre: string;
}

export interface Estudiante {
  estudiante_id: number;
  codigo_estudiante: string;
  nombre_completo: string;
  tipo_documento: string; // ENUM: CC, CE, PAS, TI
  numero_documento: string;
  fecha_nacimiento: string;
  genero: string;
  telefono?: string | null;
  celular: string;
  email_institucional: string;
  email_personal?: string | null;
  direccion?: string | null;
  ciudad?: string | null;
  foto_url?: string | null;
  foto?: string | undefined; // URL de la foto del servidor
  programa_id: number;
  semestre: number;
  jornada: string;
  promedio_acumulado?: number | null;
  estado: string;
  fecha_ingreso: string;
  fecha_creacion: string;
  fecha_actualizacion: string;
  nivel_ingles_id?: number | null;
  estado_cartera_id?: number | null;
  promocion_id?: number | null;
  contacto_emergencia?: {
    contacto_id: number;
    estudiante: number;
    nombres: string;
    apellidos: string;
    parentesco: string;
    celular: string;
    telefono?: string | null;
    correo?: string | null;
  };
  // EPS (sistema de salud) - puede venir como ID o como objeto anidado `eps_info`
  eps_id?: number | null;
  eps_info?: {
    eps_id: number;
    nombre: string;
  } | null;
}

export interface SectorEconomico {
  sector_id: number;
  nombre: string;
}

export interface TamanoEmpresa {
  tamano_id: number;
  nombre: string;
}

export enum EstadoConvenio {
  Vigente = 'Vigente',
  NoVigente = 'No Vigente',
  EnTramite = 'En Trámite'
}

export interface Empresa {
  empresa_id: number;
  razon_social: string;
  nombre_comercial?: string | null;
  sector: number; // sector_id
  tamano: number; // tamano_id
  direccion: string;
  ciudad: string;
  departamento: string;
  telefono?: string | null;
  email_empresa?: string | null;
  sitio_web?: string | null;
  cuota_sena?: number | null;
  numero_empleados?: number | null;
  nombre_persona_contacto_empresa: string;
  numero_persona_contacto_empresa?: string | null;
  cargo_persona_contacto_empresa: string;
  estado_convenio: EstadoConvenio;
  fecha_convenio?: string | null; // date
  convenio_url?: string | null;
  actividad_economica: string;
  horario_laboral?: string | null;
  trabaja_sabado?: boolean;
  observaciones?: string | null;
  estado?: boolean;
  fecha_creacion?: string;
  fecha_actualizacion?: string;
  nit_empresa?: string | null; // Campo de BD
  imagen_url_base64?: string | null; // Imagen en formato base64
  // logo_url?: string | null;  // Comentado temporalmente
}

export interface TipoContacto {
  tipo_id: number;
  nombre: string;
}

export interface ContactoEmpresa {
  contacto_id: number;
  empresa_id: number;
  nombre: string;
  cargo?: string | null;
  area?: string | null;
  telefono?: string | null;
  celular?: string | null;
  email: string;
  tipo?: string | null;
  es_principal: boolean;
  estado: boolean;
  fecha_creacion: string;
  fecha_actualizacion: string;
}

export interface OfertaEmpresa {
  oferta_id?: number;
  empresa: number;
  empresa_id?: number; // Campo adicional para compatibilidad con el backend
  descripcion: string;
  fecha_inicio: string;
  fecha_fin: string;
  programa_id?: number;
  tipo_oferta?: string;
  apoyo_economico?: string;
  valor_apoyo_economico?: number; // Valor numérico del apoyo económico cuando apoyo_economico es 'Si'
  nombre_responsable?: string;
  modalidad?: string;
}

export interface EstadoProceso {
  estado_id: number;
  nombre: string;
}

export interface ProcesoCoformacion {
  proceso_id: number;
  estudiante: number;
  empresa: number;
  oferta: number;
  fecha_inicio: string;
  fecha_fin?: string;
  estado?: number;
  observaciones?: string;
}

// Interfaces para vistas extendidas (con datos relacionados)
export interface EstudianteDetallado extends Estudiante {
  tipo_documento_nombre?: string;
  programa_nombre?: string;
  facultad_nombre?: string;
  nivel_ingles_nombre?: string;
  promocion_nombre?: string;
  estado_cartera_nombre?: string;
}

export interface EmpresaDetallada extends Empresa {
  sector_nombre?: string;
  tamano_nombre?: string;
  contactos?: ContactoEmpresa[];
}

export interface ProcesoCoformacionDetallado extends ProcesoCoformacion {
  estudiante_nombre_completo?: string;
  empresa_nombre?: string;
  estado_nombre?: string;
}

// Interfaces para autenticación/login
export interface LoginRequest {
  nombre_completo: string;
  numero_documento: string;
}

export interface LoginResponse {
  success: boolean;
  message: string;
  data: Estudiante | Empresa;
  tipo_usuario: 'estudiante' | 'empresa';
  redirect_to: string;
}

// Mantener para compatibilidad con el endpoint específico de estudiantes
export interface EstudianteLoginResponse {
  success: boolean;
  message: string;
  estudiante?: Estudiante;
  tipo_usuario?: string;
  error?: string;
} 