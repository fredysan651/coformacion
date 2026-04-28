import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { EmpresasService } from '../../services/empresas.service';
import { SectoresEconomicosService } from '../../services/sectores_economicos.service';
import { TamanosEmpresaService } from '../../services/tamanos_empresa.service';
import { ContactosEmpresaService } from '../../services/contactos_empresa.service';
import { Empresa, SectorEconomico, TamanoEmpresa, ContactoEmpresa } from '../../models/interfaces';

interface Filtros {
  sector_id: number | null;
  tamano_id: number | null;
  nombre: string;
}

@Component({
  selector: 'app-consult-empresa',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './consult-empresa.component.html',
  styleUrls: ['./consult-empresa.component.css']
})
export class ConsultEmpresaComponent implements OnInit {
  empresas: Empresa[] = [];
  empresasFiltradas: Empresa[] = [];
  sectoresEconomicos: SectorEconomico[] = [];
  tamanosEmpresa: TamanoEmpresa[] = [];
  contactosEmpresa: ContactoEmpresa[] = [];
  
  isLoading = true;
  error: string | null = null;
  searchTerm = '';

  showFilterModal = false;
  filtros: Filtros = {
    sector_id: null,
    tamano_id: null,
    nombre: ''
  };

  constructor(
    private router: Router,
    private empresasService: EmpresasService,
    private sectoresEconomicosService: SectoresEconomicosService,
    private tamanosEmpresaService: TamanosEmpresaService,
    private contactosEmpresaService: ContactosEmpresaService
  ) { }

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.isLoading = true;
    this.error = null;

    Promise.all([
      this.empresasService.getAll().toPromise(),
      this.sectoresEconomicosService.getAll().toPromise(),
      this.tamanosEmpresaService.getAll().toPromise(),
      this.contactosEmpresaService.getAll().toPromise()
    ]).then(([empresas, sectores, tamanos, contactos]) => {
      this.empresas = empresas || [];
      this.sectoresEconomicos = sectores || [];
      this.tamanosEmpresa = tamanos || [];
      this.contactosEmpresa = contactos || [];
      
      // Debug: verificar que los datos se cargaron
      console.log('Datos de empresas cargados:');
      console.log('- Empresas:', this.empresas.length);
      console.log('- Sectores económicos:', this.sectoresEconomicos.length, this.sectoresEconomicos);
      console.log('- Tamaños empresa:', this.tamanosEmpresa.length, this.tamanosEmpresa);
      console.log('- Contactos:', this.contactosEmpresa.length);
      
      this.applyAllFilters(); // Aplicar filtros después de cargar datos
      this.isLoading = false;
    }).catch(error => {
      console.error('Error cargando datos:', error);
      this.error = 'Error al cargar los datos. Por favor, intente nuevamente.';
      this.isLoading = false;
    });
  }

  refreshData() {
    this.loadData();
  }

  onSearch(value: string) {
    this.searchTerm = value;
    console.log('Búsqueda de empresa iniciada con término:', this.searchTerm);
    this.applyAllFilters();
    console.log('Resultados encontrados:', this.empresasFiltradas.length);
  }

  private applyAllFilters() {
    console.log('Aplicando filtros:', this.filtros, 'Búsqueda:', this.searchTerm);
    console.log('Total empresas:', this.empresas.length);
    
    // Primero aplicar filtros del modal
    let resultados = this.empresas.filter(empresa => {
      let cumpleFiltros = true;

      if (this.filtros.sector_id && this.filtros.sector_id !== null) {
        const sectorIdFiltro = Number(this.filtros.sector_id);
        cumpleFiltros = cumpleFiltros && empresa.sector === sectorIdFiltro;
        console.log(`Filtro sector: ${empresa.sector} === ${sectorIdFiltro}?`, empresa.sector === sectorIdFiltro);
      }

      if (this.filtros.tamano_id && this.filtros.tamano_id !== null) {
        const tamanoIdFiltro = Number(this.filtros.tamano_id);
        cumpleFiltros = cumpleFiltros && empresa.tamano === tamanoIdFiltro;
        console.log(`Filtro tamaño: ${empresa.tamano} === ${tamanoIdFiltro}?`, empresa.tamano === tamanoIdFiltro);
      }

      if (this.filtros.nombre && this.filtros.nombre.trim()) {
        const nombreFiltro = this.filtros.nombre.toLowerCase();
        cumpleFiltros = cumpleFiltros && 
          (empresa.nombre_comercial || '').toLowerCase().includes(nombreFiltro);
        console.log(`Filtro nombre: ${empresa.nombre_comercial} incluye ${nombreFiltro}?`, 
          (empresa.nombre_comercial || '').toLowerCase().includes(nombreFiltro));
      }

      return cumpleFiltros;
    });

    console.log('Después de filtros del modal:', resultados.length, 'empresas');

    // Luego aplicar búsqueda de texto
    if (this.searchTerm && this.searchTerm.trim()) {
      const searchLower = this.searchTerm.toLowerCase();
      resultados = resultados.filter(empresa => 
        (empresa.nombre_comercial || '').toLowerCase().includes(searchLower) ||
        (empresa.nit_empresa || '').includes(searchLower) ||
        this.getSectorNombre(empresa.sector).toLowerCase().includes(searchLower)
      );
      console.log('Después de búsqueda de texto:', resultados.length, 'empresas');
    }

    this.empresasFiltradas = resultados;
    console.log('Resultado final:', this.empresasFiltradas.length, 'empresas mostradas');
  }

  getSectorNombre(sectorId: number | null | undefined): string {
    if (!sectorId) return 'N/A';
    const sector = this.sectoresEconomicos.find(s => s.sector_id === sectorId);
    return sector ? sector.nombre : 'N/A';
  }

  getTamanoNombre(tamanoId: number | null | undefined): string {
    if (!tamanoId) return 'N/A';
    const tamano = this.tamanosEmpresa.find(t => t.tamano_id === tamanoId);
    return tamano ? tamano.nombre : 'N/A';
  }

  getContactosCount(empresaId: number): number {
    return this.contactosEmpresa.filter(c => c.empresa_id === empresaId).length;
  }

  applyFilters() {
    console.log('=== APLICANDO FILTROS DE EMPRESA ===');
    console.log('Filtros seleccionados:', this.filtros);
    this.applyAllFilters();
    this.toggleFilterModal();
  }

  toggleFilterModal() {
    this.showFilterModal = !this.showFilterModal;
    if (this.showFilterModal) {
      console.log('Modal de filtros de empresa abierto - Datos disponibles:');
      console.log('- Sectores económicos para filtro:', this.sectoresEconomicos.length);
      console.log('- Tamaños empresa para filtro:', this.tamanosEmpresa.length);
      console.log('- Filtros actuales:', this.filtros);
    }
  }

  cancelarFiltros() {
    this.showFilterModal = false;
  }

  onFilterChange(filterType: string, event: any) {
    const value = event.target.value;
    console.log(`Filtro de empresa ${filterType} cambiado a:`, value, 'tipo:', typeof value);
    
    // No aplicar filtros automáticamente, solo cuando se presione APLICAR
    // Este método es solo para debugging
  }

  clearFilters() {
    this.filtros = {
      sector_id: null,
      tamano_id: null,
      nombre: ''
    };
    this.applyAllFilters();
  }

  onDetails(empresa: Empresa) {
  }

  goToResumenEmpresa(empresa: Empresa) {
    // TODO: Pasar el ID de la empresa a la ruta
    this.router.navigate(['/resumen-empresa'], { queryParams: { id: empresa.empresa_id } });
  }

  goToEditarEmpresa(empresa: Empresa) {
    this.router.navigate(['/editar-empresa'], { queryParams: { id: empresa.empresa_id } });
  }

  navegarAgregarEmpresa() {
    this.router.navigate(['/agregar-empresa']);
  }

  volverAlHome(): void {
    this.router.navigate(['/coformacion']);
  }
}
