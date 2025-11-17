from django.urls import path
from . import views

urlpatterns = [
    path('', views.admin_home, name='admin_home'),

    # Usuarios
    path('usuarios/', views.usuarios_list, name='usuarios_list'),

    # Empleados
    path('empleados/', views.empleados_list, name='empleados_list'),

    # Formulario unificado
    path('crear/', views.crear_usuario_empleado, name='crear_usuario_empleado'),
]
