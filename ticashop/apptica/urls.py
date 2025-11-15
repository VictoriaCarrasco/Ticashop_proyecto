from django.urls import path
from . import views

urlpatterns = [
    # Dashboard
    path('', views.dashboard, name='dashboard'),

    # Vacaciones
    path('vacaciones/', views.vacaciones_list, name='vacaciones_list'),
    path('vacaciones/export/', views.vacaciones_export, name='vacaciones_export'),
    path('vacaciones/firmar/', views.vacaciones_firmar, name='vacaciones_firmar'),
    path('vacaciones/nueva/', views.vacaciones_nueva, name='vacaciones_nueva'),
    path('vacaciones/<int:pk>/', views.vacaciones_detalle, name='vacaciones_detalle'),
    path('vacaciones/<int:pk>/aprobar/', views.vacaciones_aprobar, name='vacaciones_aprobar'),
    path('vacaciones/<int:pk>/rechazar/', views.vacaciones_rechazar, name='vacaciones_rechazar'),

    # Liquidaciones
    path('liquidaciones/', views.liquidaciones_list, name='liquidaciones_list'),
    path('liquidaciones/nueva/', views.liquidaciones_generar, name='liquidaciones_generar'),
    path('liquidaciones/<int:pk>/', views.liquidaciones_detalle, name='liquidaciones_detalle'),
    path("liquidaciones/<int:pk>/pdf/", views.liquidacion_pdf, name="liquidacion_pdf"),
    


    # Comisiones
    path('comisiones/', views.comisiones_list, name='comisiones_list'),
    path('comisiones/calcular/', views.comisiones_calcular, name='comisiones_calcular'),
    path('comisiones/export/', views.comisiones_export, name='comisiones_export'),
    path('comisiones/<int:pk>/', views.comisiones_detalle, name='comisiones_detalle'),

    # Asistencia
    path('asistencia/', views.asistencia_list, name='asistencia_list'),
    path('asistencia/export/', views.asistencia_export, name='asistencia_export'),

    # Usuarios
    path('usuarios/', views.usuarios_list, name='usuarios_list'),
    path('usuarios/nuevo/', views.usuarios_new, name='usuarios_new'),
    path('usuarios/<int:pk>/', views.usuarios_view, name='usuarios_view'),
    path('usuarios/<int:pk>/editar/', views.usuarios_edit, name='usuarios_edit'),
    path('usuarios/<int:pk>/eliminar/', views.usuarios_delete, name='usuarios_delete'),

    path('usuarios/export/', views.usuarios_export, name='usuarios_export'),

]
