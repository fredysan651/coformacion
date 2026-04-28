import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // Obtener el token de autenticación
    const token = this.authService.getToken();
    
    // Obtener el estudiante_id si es estudiante
    const currentUser = this.authService.getCurrentUser();
    const userType = this.authService.getUserType();
    
    let headers = request.headers;
    
    console.log('🔍 INTERCEPTOR DEBUG:', {
      userType,
      currentUser,
      estudiante_id: currentUser?.estudiante_id,
      url: request.url
    });
    
    // Si hay token, agregarlo a los headers
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }
    
    // Si es estudiante, agregar el estudiante_id en el header para filtrado en el backend
    if (userType === 'estudiante' && currentUser && currentUser.estudiante_id) {
      console.log('✅ Agregando X-Student-Id:', currentUser.estudiante_id);
      headers = headers.set('X-Student-Id', currentUser.estudiante_id.toString());
    } else {
      console.log('❌ No se agregó X-Student-Id. Condiciones:', {
        isEstudiante: userType === 'estudiante',
        hasCurrentUser: !!currentUser,
        hasEstudianteId: !!currentUser?.estudiante_id
      });
    }
    
    request = request.clone({ headers });

    // Continuar con la petición y manejar errores de autenticación
    return next.handle(request).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401) {
          // Token inválido o expirado - cerrar sesión y redirigir
          console.warn('Token inválido o expirado. Cerrando sesión...');
          this.authService.logout();
        } else if (error.status === 403) {
          // Sin permisos para acceder al recurso
          console.warn('Sin permisos para acceder al recurso');
          this.authService.redirectToUserHome();
        }
        
        return throwError(() => error);
      })
    );
  }
} 