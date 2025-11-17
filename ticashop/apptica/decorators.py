from django.shortcuts import redirect
from functools import wraps
from .models import Empleado

def validar_rol(roles_permitidos):
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            if not request.user.is_authenticated:
                return redirect("login_empleado")

            try:
                empleado = Empleado.objects.get(email=request.user.email)
            except Empleado.DoesNotExist:
                return redirect("login_empleado")

            if empleado.rol not in roles_permitidos:
                return redirect("dashboard")  # Acceso denegado → dashboard
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator
