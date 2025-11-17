from .models import Empleado

def empleado_context(request):
    if not request.user.is_authenticated:
        return {}

    try:
        empleado = Empleado.objects.get(email=request.user.email)
    except Empleado.DoesNotExist:
        empleado = None

    return {"empleado_actual": empleado}
