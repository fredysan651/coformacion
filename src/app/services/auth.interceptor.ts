import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authService: AuthService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const currentSession = this.authService.getCurrentUser();
    
    if (currentSession && currentSession.user && currentSession.user.estudiante_id) {
      // Si es estudiante, agregar el estudiante_id en el header
      if (currentSession.tipo_usuario === 'estudiante') {
        request = request.clone({
          setHeaders: {
            'X-Student-Id': currentSession.user.estudiante_id.toString()
          }
        });
      }
    }

    return next.handle(request);
  }
}
