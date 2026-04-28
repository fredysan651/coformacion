import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-debug',
  standalone: true,
  template: `
    <div style="padding: 20px; background: #ffcccc; border: 3px solid red; margin: 10px; font-size: 12px;">
      <h3>🔴 DEBUG - STORAGE CHECK</h3>
      <p><strong>localStorage.userSession:</strong></p>
      <pre>{{ localStorage_userSession | json }}</pre>
      
      <p><strong>AuthService.getCurrentUser():</strong></p>
      <pre>{{ currentUser | json }}</pre>
      
      <p><strong>AuthService.getUserType():</strong></p>
      <pre>{{ userType }}</pre>
      
      <p><strong>Estudiante ID:</strong></p>
      <pre>{{ currentUser?.estudiante_id }}</pre>
      
      <p><strong>sessionStorage.estudiante_id:</strong></p>
      <pre>{{ sessionStorage_estudiante_id }}</pre>
    </div>
  `
})
export class DebugComponent implements OnInit {
  localStorage_userSession: any = null;
  currentUser: any = null;
  userType: any = null;
  sessionStorage_estudiante_id: any = null;

  constructor(private authService: AuthService) {}

  ngOnInit() {
    // Get from localStorage
    const stored = localStorage.getItem('userSession');
    this.localStorage_userSession = stored ? JSON.parse(stored) : null;
    
    // Get from AuthService
    this.currentUser = this.authService.getCurrentUser();
    this.userType = this.authService.getUserType();
    
    // Get from sessionStorage
    this.sessionStorage_estudiante_id = sessionStorage.getItem('estudiante_id');
    
    console.log('✅ DEBUG COMPONENT LOADED:', {
      localStorage_userSession: this.localStorage_userSession,
      currentUser: this.currentUser,
      userType: this.userType,
      sessionStorage_estudiante_id: this.sessionStorage_estudiante_id
    });
  }
}

