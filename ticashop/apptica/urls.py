from django.urls import path
from . import views

urlpatterns = [
    # Login / Logout
    path('login/', views.login_empleado, name='login_empleado'),
    path('logout/', views.logout_empleado, name='logout_empleado'),

    # Dashboard
    path('', views.dashboard, name='dashboard'),

    path('admin/', views.admin_home, name='admin_home'),
    path('admin/usuarios/', views.usuarios_list, name='usuarios_list'),
    path('admin/usuarios/nuevo/', views.usuario_create, name='usuario_create'),
    path('admin/empleados/', views.empleados_list, name='empleados_list'),
    path("admin/empleados/<int:pk>/editar/", views.empleado_edit, name="empleado_edit"),
    path(
        "admin/empleados/<int:pk>/activar-desactivar/",
        views.empleado_toggle_activo,
        name="empleado_toggle_activo",
    ),

    # Vacaciones
    path('vacaciones/', views.vacaciones_list, name='vacaciones_list'),
    path('vacaciones/restablecer/', views.vacaciones_restablecer, name='vacaciones_restablecer'),
    path('vacaciones/export/', views.vacaciones_export, name='vacaciones_export'),
    path('vacaciones/solicitar/', views.vacaciones_solicitar, name='vacaciones_solicitar'),
    path('vacaciones/nueva/', views.vacaciones_nueva, name='vacaciones_nueva'),
    path('vacaciones/<int:pk>/', views.vacaciones_detalle, name='vacaciones_detalle'),
    path('vacaciones/<int:pk>/aprobar/', views.vacaciones_aprobar, name='vacaciones_aprobar'),
    path('vacaciones/<int:pk>/rechazar/', views.vacaciones_rechazar, name='vacaciones_rechazar'),

    # Liquidaciones
    path('liquidaciones/', views.liquidaciones_list, name='liquidaciones_list'),
    path('liquidaciones/nueva/', views.liquidaciones_generar, name='liquidaciones_generar'),
    path('liquidaciones/<int:pk>/', views.liquidaciones_detalle, name='liquidaciones_detalle'),
    path("liquidaciones/<int:pk>/pdf/", views.liquidacion_pdf, name="liquidacion_pdf"),
    path('liquidaciones/<int:pk>/firmar/', views.liquidacion_firmar, name='liquidacion_firmar'),
    


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
