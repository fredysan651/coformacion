import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiConfigService } from './api-config.service';

export interface DocumentoProceso {
  documento_id?: number;
  proceso: number;
  tipo_doc: number;
  url_documento: string;
  fecha_envio?: string;
  fecha_revision?: string;
  fecha_aprobacion?: string;
  estado?: string;
  observaciones?: string;
  revisado_por?: number;
  fecha_creacion?: string;
  fecha_actualizacion?: string;
}

@Injectable({
  providedIn: 'root'
})
export class DocumentosProcesoService {

  private apiUrl: string;

  constructor(private http: HttpClient, private apiConfig: ApiConfigService) { 
    this.apiUrl = this.apiConfig.getDocumentosProcesoUrl();
  }

  getAll(): Observable<DocumentoProceso[]> {
    return this.http.get<DocumentoProceso[]>(this.apiUrl);
  }

  getById(id: number): Observable<DocumentoProceso> {
    return this.http.get<DocumentoProceso>(`${this.apiUrl}${id}/`);
  }

  getByProcesoId(procesoId: number, estudianteId?: number): Observable<DocumentoProceso[]> {
    let url = `${this.apiUrl}?proceso_id=${procesoId}`;
    if (estudianteId) {
      url += `&estudiante_id=${estudianteId}`;
    }
    return this.http.get<DocumentoProceso[]>(url);
  }

  create(data: DocumentoProceso): Observable<DocumentoProceso> {
    return this.http.post<DocumentoProceso>(this.apiUrl, data);
  }

  update(id: number, data: DocumentoProceso): Observable<DocumentoProceso> {
    return this.http.put<DocumentoProceso>(`${this.apiUrl}${id}/`, data);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}${id}/`);
  }

  uploadFile(file: File, procesoId: number, tipoDocId: number): Observable<any> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('proceso_id', procesoId.toString());
    formData.append('tipo_doc_id', tipoDocId.toString());
    
    return this.http.post<any>(`${this.apiUrl}upload/`, formData);
  }
}
