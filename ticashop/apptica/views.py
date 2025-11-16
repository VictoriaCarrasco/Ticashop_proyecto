from datetime import date, datetime
from decimal import Decimal

from django.contrib import messages
from django.db.models import Count, Q, Sum
from django.http import HttpResponse, HttpResponseNotAllowed
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone
from django.template.loader import render_to_string
from io import BytesIO
from django.template.loader import get_template
from xhtml2pdf import pisa
from .models import Liquidacion, Empleado, Venta, ComisionVenta


from .forms import EmpleadoForm
from .models import (
    Empleado,
    SolicitudVacacional,
    Liquidacion,
    ComisionVenta,
    RegistroAsistencia,
)

# ===========================
# Dashboard
# ===========================
def dashboard(request):
    hoy = timezone.localdate()
    total_empleados = Empleado.objects.count()
    presentes_hoy = RegistroAsistencia.objects.filter(fecha=hoy, estado="PRESENTE").count()
    vacaciones_pendientes = SolicitudVacacional.objects.filter(estado="PENDIENTE").count()
    liquidaciones_pendientes = Liquidacion.objects.filter(estado="PENDIENTE_FIRMA").count()
    comisiones_pendientes = ComisionVenta.objects.filter(estado="PENDIENTE").count()

    ctx = dict(
        total_empleados=total_empleados,
        presentes_hoy=presentes_hoy,
        vacaciones_pendientes=vacaciones_pendientes,
        liquidaciones_pendientes=liquidaciones_pendientes,
        comisiones_pendientes=comisiones_pendientes,
    )
    return render(request, "dashboard.html", ctx)


# ===========================
# Vacaciones
# ===========================
def vacaciones_list(request):
    qs = (SolicitudVacacional.objects
          .select_related("empleado")
          .order_by("-fecha_inicio", "-id"))
    return render(request, "vacaciones_list.html", {"solicitudes": qs})

def vacaciones_export(request):
    # CSV simple
    rows = (SolicitudVacacional.objects
            .select_related("empleado")
            .values_list("empleado__nombre", "fecha_inicio", "fecha_fin", "dias", "estado"))
    resp = HttpResponse(content_type="text/csv; charset=utf-8")
    resp["Content-Disposition"] = 'attachment; filename="vacaciones.csv"'
    resp.write("empleado,fecha_inicio,fecha_fin,dias,estado\n")
    for r in rows:
        resp.write(",".join([str(x) for x in r]) + "\n")
    return resp

def vacaciones_firmar(request):
    messages.info(request, "Funcionalidad de firma digital: demo.")
    return redirect("vacaciones_list")

def vacaciones_nueva(request):
    # Placeholder: muestra un aviso (puedes crear un formulario si quieres)
    messages.info(request, "Formulario de nueva solicitud no implementado (demo).")
    return redirect("vacaciones_list")

def vacaciones_detalle(request, pk: int):
    v = get_object_or_404(SolicitudVacacional.objects.select_related("empleado"), pk=pk)
    # Reutilizamos la tabla y resaltamos la fila, o crea un template detalle si lo prefieres
    return render(request, "vacaciones_list.html", {"solicitudes": [v]})

def vacaciones_aprobar(request, pk: int):
    if request.method != "GET":
        return HttpResponseNotAllowed(["GET"])
    v = get_object_or_404(SolicitudVacacional, pk=pk)
    v.estado = "APROBADA"
    v.save(update_fields=["estado"])
    messages.success(request, f"Solicitud #{v.pk} aprobada.")
    return redirect("vacaciones_list")

def vacaciones_rechazar(request, pk: int):
    if request.method != "GET":
        return HttpResponseNotAllowed(["GET"])
    v = get_object_or_404(SolicitudVacacional, pk=pk)
    v.estado = "RECHAZADA"
    v.save(update_fields=["estado"])
    messages.success(request, f"Solicitud #{v.pk} rechazada.")
    return redirect("vacaciones_list")


# ===========================
# Liquidaciones
# ===========================

def render_to_pdf(template_src, context_dict=None):
    """
    Renderiza una plantilla HTML a PDF usando xhtml2pdf.
    Devuelve bytes o None si hay error.
    """
    if context_dict is None:
        context_dict = {}

    template = get_template(template_src)
    html = template.render(context_dict)

    result = BytesIO()
    pdf = pisa.pisaDocument(
        BytesIO(html.encode("UTF-8")),
        dest=result,
        encoding="UTF-8"
    )

    if pdf.err:
        # Si hay error, devolvemos None
        return None

    return result.getvalue()




def liquidaciones_list(request):
    qs = Liquidacion.objects.select_related("empleado").order_by("-periodo", "-id")
    return render(request, "liquidaciones_list.html", {"liquidaciones": qs})


def liquidaciones_generar(request):
    # Usamos el primer día del mes como "periodo" de la liquidación
    hoy = timezone.now()
    periodo = date(hoy.year, hoy.month, 1)

    empleados = Empleado.objects.all()
    creadas = 0

    SUELDO_BASE_DEMO = Decimal("1000000.00")  # lo que estás usando como sueldo base

    for e in empleados:
        # 1) Buscamos la comisión de ventas para este empleado y este mes
        comision_reg = ComisionVenta.objects.filter(
            empleado=e,
            periodo__year=periodo.year,
            periodo__month=periodo.month,
        ).order_by("-id").first()

        comision = comision_reg.comision if comision_reg else Decimal("0")

        # 2) Creamos o actualizamos la liquidación con esa comisión
        obj, created = Liquidacion.objects.update_or_create(
            empleado=e,
            periodo=periodo,
            defaults={
                "monto_total": SUELDO_BASE_DEMO,
                "estado": "PENDIENTE_FIRMA",
                "comisiones": comision,  # 👈 AQUÍ guardamos la comisión calculada
            },
        )

        if created:
            creadas += 1

    messages.success(request, f"Se generaron/actualizaron {creadas} liquidaciones.")
    return redirect("liquidaciones_list")



def liquidaciones_detalle(request, pk: int):
    l = get_object_or_404(Liquidacion.objects.select_related("empleado"), pk=pk)
    # Para mantener simple, reusamos la lista filtrada
    return render(request, "liquidaciones_list.html", {"liquidaciones": [l]})


def liquidacion_pdf(request, pk: int):
    liquidacion = get_object_or_404(
        Liquidacion.objects.select_related("empleado"),
        pk=pk
    )

    sueldo_base = liquidacion.monto_total
    comisiones = liquidacion.comisiones or Decimal("0")

    GRAT_RATE = Decimal("0.25")
    gratificacion = sueldo_base * GRAT_RATE

    imponible = sueldo_base + gratificacion + comisiones
    AFP_RATE = Decimal("0.10")
    SALUD_RATE = Decimal("0.07")
    SEGURO_RATE = Decimal("0.006")

    afp = imponible * AFP_RATE
    salud = imponible * SALUD_RATE
    seguro = imponible * SEGURO_RATE
    impuesto = Decimal("0")

    total_descuentos = afp + salud + seguro + impuesto
    liquido = imponible - total_descuentos

    context = {
        "liquidacion": liquidacion,
        "sueldo_base": sueldo_base,
        "gratificacion": gratificacion,
        "comisiones": comisiones,     # 👈 viene del modelo
        "imponible": imponible,
        "afp": afp,
        "salud": salud,
        "seguro": seguro,
        "impuesto": impuesto,
        "total_descuentos": total_descuentos,
        "liquido": liquido,
    }

    pdf_bytes = render_to_pdf("liquidacion_pdf.html", context)
    if pdf_bytes is None:
        return HttpResponse("Error al generar el PDF", status=500)

    filename = f"liquidacion_{liquidacion.empleado.rut}_{liquido:.0f}.pdf"
    response = HttpResponse(pdf_bytes, content_type="application/pdf")
    response["Content-Disposition"] = f'attachment; filename=\"{filename}\"'
    return response



# ===========================
# Comisiones
# ===========================
def comisiones_list(request):
    qs = ComisionVenta.objects.select_related("empleado").order_by("-periodo", "-id")
    return render(request, "comisiones.html", {"comisiones": qs})

def comisiones_calcular(request):
    # DEMO: recalcula comisión = 1.5% de ventas_totales
    qs = ComisionVenta.objects.all()
    for c in qs:
        c.comision = (c.ventas_totales or Decimal("0")) * Decimal("0.015")
        c.estado = "CALCULADA"
        c.save(update_fields=["comision", "estado"])
    messages.success(request, "Comisiones recalculadas.")
    return redirect("comisiones_list")

def comisiones_export(request):
    qs = ComisionVenta.objects.select_related("empleado").values_list(
        "empleado__nombre", "periodo", "ventas_totales", "comision", "estado"
    )
    resp = HttpResponse(content_type="text/csv; charset=utf-8")
    resp["Content-Disposition"] = 'attachment; filename="comisiones.csv"'
    resp.write("empleado,periodo,ventas_totales,comision,estado\n")
    for r in qs:
        resp.write(",".join([str(x) for x in r]) + "\n")
    return resp

def comisiones_detalle(request, pk: int):
    c = get_object_or_404(ComisionVenta.objects.select_related("empleado"), pk=pk)
    return render(request, "comisiones.html", {"comisiones": [c]})


# ===========================
# Asistencia
# ===========================
def asistencia_list(request):
    qs = RegistroAsistencia.objects.select_related("empleado").order_by("-fecha", "empleado__nombre")

    # filtros GET: desde, hasta, q (nombre o rut)
    desde = request.GET.get("desde")
    hasta = request.GET.get("hasta")
    q = request.GET.get("q")

    if desde:
        qs = qs.filter(fecha__gte=desde)
    if hasta:
        qs = qs.filter(fecha__lte=hasta)
    if q:
        qs = qs.filter(Q(empleado__nombre__icontains=q) | Q(empleado__rut__icontains=q))

    return render(request, "asistencia.html", {"registros": qs})

def asistencia_export(request):
    qs = RegistroAsistencia.objects.select_related("empleado").values_list(
        "empleado__nombre", "fecha", "hora_entrada", "hora_salida", "horas_trabajadas", "estado"
    )
    resp = HttpResponse(content_type="text/csv; charset=utf-8")
    resp["Content-Disposition"] = 'attachment; filename="asistencia.csv"'
    resp.write("empleado,fecha,entrada,salida,horas,estado\n")
    for r in qs:
        resp.write(",".join([str(x) for x in r]) + "\n")
    return resp


# ===========================
# Usuarios (Empleados)
# ===========================
def usuarios_list(request):
    qs = Empleado.objects.all().order_by("nombre")
    return render(request, "usuarios_list.html", {"usuarios": qs})

def usuarios_new(request):
    if request.method == "POST":
        form = EmpleadoForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Usuario creado.")
            return redirect("usuarios_list")
    else:
        form = EmpleadoForm()
    return render(request, "usuarios_form.html", {"form": form, "titulo": "Nuevo Usuario"})

def usuarios_view(request, pk: int):
    u = get_object_or_404(Empleado, pk=pk)
    # Para simplificar, reusamos la lista con solo ese usuario
    return render(request, "usuarios_list.html", {"usuarios": [u]})

def usuarios_edit(request, pk: int):
    u = get_object_or_404(Empleado, pk=pk)
    if request.method == "POST":
        form = EmpleadoForm(request.POST, instance=u)
        if form.is_valid():
            form.save()
            messages.success(request, "Usuario actualizado.")
            return redirect("usuarios_list")
    else:
        form = EmpleadoForm(instance=u)
    return render(request, "usuarios_form.html", {"form": form, "titulo": "Editar Usuario"})

def usuarios_delete(request, pk: int):
    u = get_object_or_404(Empleado, pk=pk)
    u.delete()
    messages.success(request, "Usuario eliminado.")
    return redirect("usuarios_list")

def usuarios_export(request):
    qs = Empleado.objects.values_list("nombre", "email", "rut", "rol", "departamento", "activo")
    resp = HttpResponse(content_type="text/csv; charset=utf-8")
    resp["Content-Disposition"] = 'attachment; filename="usuarios.csv"'
    resp.write("nombre,email,rut,rol,departamento,activo\n")
    for r in qs:
        resp.write(",".join([str(x) for x in r]) + "\n")
    return resp
