import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiConfigService } from './api-config.service';
import { LoginRequest, LoginResponse, EstudianteLoginResponse } from '../models/interfaces';

@Injectable({
  providedIn: 'root'
})
export class EstudiantesService {

  private apiUrl: string;

  constructor(private http: HttpClient, private apiConfig: ApiConfigService) { 
    this.apiUrl = this.apiConfig.getEstudiantesUrl();
  }

  getAll(): Observable<any[]> {
    return this.http.get<any[]>(this.apiUrl);
  }

  getById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}${id}/`);
  }

  create(data: any): Observable<any> {
    return this.http.post<any>(this.apiUrl, data);
  }

  update(id: number, data: any): Observable<any> {
    return this.http.put<any>(`${this.apiUrl}${id}/`, data);
  }

  delete(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}${id}/`);
  }

  // Método de login universal (detecta automáticamente estudiante o empresa)
  loginUniversal(loginData: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.apiConfig.getBaseUrl()}/auth/login/`, loginData);
  }

  // Método para login de estudiantes (mantenido por compatibilidad)
  login(nombre_completo: string, numero_documento: string): Observable<any> {
    const loginData = {
      nombre_completo: nombre_completo,
      numero_documento: numero_documento
    };
    
    const loginUrl = `${this.apiConfig.getBaseUrl()}/auth/login-estudiante/`;
    return this.http.post<any>(loginUrl, loginData);
  }

  // Método para subir foto de estudiante
  subirFoto(estudianteId: number, formData: FormData): Observable<any> {
    return this.http.post<any>(
      `${this.apiUrl}${estudianteId}/upload-foto/`,
      formData
    );
  }
}
