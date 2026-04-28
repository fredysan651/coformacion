from django.urls import path, include
from . import views
from rest_framework.routers import DefaultRouter
from .views import recomendaciones_por_estudiante, recomendaciones_completas
from .diagnostico import diagnostico_headers
from .views import *


router = DefaultRouter()
router.register(r'roles', RolesViewSet)
router.register(r'permisos', PermisosViewSet)
router.register(r'roles-permisos', RolesPermisosViewSet)
router.register(r'tipos-documento', TiposDocumentoViewSet)
router.register(r'facultades', FacultadesViewSet)
router.register(r'programas', ProgramasViewSet)
router.register(r'materias-nucleo', MateriasNucleoViewSet)
router.register(r'objetivos-aprendizaje', ObjetivosAprendizajeViewSet)
router.register(r'promociones', PromocionesViewSet)
router.register(r'niveles-ingles', NivelesInglesViewSet)
router.register(r'estados-cartera', EstadosCarteraViewSet)
router.register(r'estudiantes', EstudiantesViewSet)
router.register(r'estudiantes-eps', EstudiantesEpsViewSet)
router.register(r'sectores-economicos', SectoresEconomicosViewSet)
router.register(r'tamanos-empresa', TamanosEmpresaViewSet)
router.register(r'empresas', EmpresasViewSet)
router.register(r'tipos-contacto', TiposContactoViewSet)
router.register(r'contactos-empresa', ContactosEmpresaViewSet)
router.register(r'ofertas-empresas', OfertasEmpresasViewSet)
router.register(r'estado-proceso', EstadoProcesoViewSet)
router.register(r'proceso-coformacion', ProcesoCoformacionViewSet, basename='proceso-coformacion')
router.register(r'documentos-proceso', DocumentosProcesoViewSet, basename='documentos-proceso')
router.register(r'tipos-actividad', TiposActividadViewSet)
router.register(r'calendario-actividades', CalendarioActividadesViewSet)
router.register(r'plantillas-correo', PlantillasCorreoViewSet)
router.register(r'historial-comunicaciones', HistorialComunicacionesViewSet)
router.register(r'coformacion', CoformacionViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('diagnostico-headers/', diagnostico_headers, name='diagnostico_headers'),
    path('auth/login/', login_universal, name='login_universal'),
    path('auth/login-estudiante/', login_estudiante, name='login_estudiante'),
    path('recomendar-ofertas/', views.recomendar_ofertas, name='recomendar_ofertas'),
    path('recomendaciones/<int:estudiante_id>/', recomendaciones_por_estudiante, name='recomendaciones_por_estudiante'),
    path('recomendaciones-completas/', recomendaciones_completas, name='recomendaciones_completas')
]
