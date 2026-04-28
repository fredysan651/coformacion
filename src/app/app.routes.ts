import { Routes } from '@angular/router';
import { CoformacionListComponent } from './components/coformacion/coformacion-list/coformacion-list.component';
import { CoformacionFormComponent } from './components/coformacion/coformacion-form/coformacion-form.component';
import { CoformacionComponent } from './pages/coformacion/coformacion.component';

// Importar guards
import { AuthGuard } from './guards/auth.guard';
import { PublicGuard } from './guards/public.guard';
import { EmpresaGuard } from './guards/empresa.guard';
import { EstudianteGuard } from './guards/estudiante.guard';
import { CoformacionGuard } from './guards/coformacion.guard';
import { EstudianteOrCoformacionGuard } from './guards/estudiante-or-coformacion.guard';

export const routes: Routes = [
  // Rutas públicas (sin autenticación)
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { 
    path: 'home', 
    loadComponent: () => import('./pages/home/home.component').then(m => m.HomeComponent)
  },
  { 
    path: 'login', 
    canActivate: [PublicGuard],
    loadComponent: () => import('./pages/login/login.component').then(m => m.LoginComponent) 
  },

  // Rutas específicas para empresas
  { 
    path: 'home-empresa', 
    canActivate: [EmpresaGuard],
    loadComponent: () => import('./pages/home-empresa/home-empresa.component').then(m => m.HomeEmpresaComponent)
  },
  { 
    path: 'editar-empresa', 
    canActivate: [AuthGuard], // Permitir acceso a empresas y coformación
    loadComponent: () => import('./pages/editar-empresa/editar-empresa.component').then(m => m.EditarEmpresaComponent) 
  },
  { 
    path: 'informacion-empresa', 
    canActivate: [EmpresaGuard],
    loadComponent: () => import('./pages/informacion-empresa/informacion-empresa.component').then(m => m.InformacionEmpresaComponent) 
  },
  { 
    path: 'publicar-oferta', 
    canActivate: [EmpresaGuard],
    loadComponent: () => import('./pages/publicar-oferta/publicar-oferta.component').then(m => m.PublicarOfertaComponent) 
  },

  // Rutas específicas para estudiantes
  { 
    path: 'perfil-estudiante', 
    canActivate: [EstudianteGuard],
    loadComponent: () => import('./pages/perfil-estudiante/perfil-estudiante.component').then(m => m.PerfilEstudianteComponent) 
  },
  { 
    path: 'perfil-estudiante/:id', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/perfil-estudiante/perfil-estudiante.component').then(m => m.PerfilEstudianteComponent) 
  },
  { 
    path: 'historial-coformacion', 
    canActivate: [EstudianteOrCoformacionGuard],
    loadComponent: () => import('./pages/historial-coformacion/historial-coformacion.component').then(m => m.HistorialCoformacionComponent) 
  },
  { 
    path: 'editar-estudiante', 
    canActivate: [EstudianteOrCoformacionGuard],
    loadComponent: () => import('./pages/editar-estudiante/editar-estudiante.component').then(m => m.EditarEstudianteComponent) 
  },
  { 
    path: 'proceso-coformacion', 
    canActivate: [EstudianteOrCoformacionGuard],
    loadComponent: () => import('./pages/proceso-coformacion/proceso-coformacion.component').then(m => m.ProcesoCoformacionComponent) 
  },
  { 
    path: 'documentos-proceso/:procesoId', 
    canActivate: [EstudianteOrCoformacionGuard],
    loadComponent: () => import('./pages/documentos-proceso/documentos-proceso.component').then(m => m.DocumentosProcesoComponent) 
  },

  // Rutas administrativas (solo coformación)
  { 
    path: 'consult-empresa', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/consult-empresa/consult-empresa.component').then(m => m.ConsultEmpresaComponent) 
  },
  { 
    path: 'consult-estudent', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/consult-estudent/consult-estudent.component').then(m => m.ConsultEstudentComponent) 
  },
  { 
    path: 'ofertas-coformacion', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/ofertas-coformacion/ofertas-coformacion.component').then(m => m.OfertasCoformacionComponent) 
  },
  { 
    path: 'agregar-empresa', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/agregar-empresa/agregar-empresa.component').then(m => m.AgregarEmpresaComponent) 
  },
  { 
    path: 'agregar-estudiante', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/agregar-estudiante/agregar-estudiante.component').then(m => m.AgregarEstudianteComponent) 
  },
  { 
    path: 'resumen-empresa', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/resumen-empresa/resumen-empresa.component').then(m => m.ResumenEmpresaComponent) 
  },

  // Rutas de coformación (solo coformación puede acceder)
  { 
    path: 'coformacion', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/coformacion/coformacion.component').then(m => m.CoformacionComponent) 
  },
  { 
    path: 'coformacion/nueva', 
    canActivate: [CoformacionGuard],
    component: CoformacionFormComponent 
  },
  { 
    path: 'coformacion/editar/:id', 
    canActivate: [CoformacionGuard],
    component: CoformacionFormComponent 
  },
  { 
    path: 'diagnostico', 
    canActivate: [CoformacionGuard],
    loadComponent: () => import('./pages/diagnostico/diagnostico.component').then(m => m.DiagnosticoComponent) 
  },

  // Ruta por defecto - redirigir a home si no se encuentra la ruta
  { path: '**', redirectTo: '/home' }
];
