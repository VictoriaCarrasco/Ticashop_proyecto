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
# ===========================
# Liquidaciones
# ===========================

def render_to_pdf(template_src, context_dict=None):
    """
    Renderiza una plantilla HTML a PDF usando xhtml2pdf.
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

    if not pdf.err:
        return result.getvalue()
    return None


def liquidaciones_list(request):
    qs = Liquidacion.objects.select_related("empleado").order_by("-periodo", "-id")
    return render(request, "liquidaciones_list.html", {"liquidaciones": qs})


def liquidaciones_generar(request):
    # DEMO: genera liquidaciones del mes actual para todos los empleados que no tengan
    periodo = date(timezone.now().year, timezone.now().month, 1)
    empleados = Empleado.objects.all()
    creadas = 0
    for e in empleados:
        obj, created = Liquidacion.objects.get_or_create(
            empleado=e, periodo=periodo,
            defaults=dict(monto_total=Decimal("1000000.00"), estado="PENDIENTE_FIRMA")
        )
        if created:
            creadas += 1
    messages.success(request, f"Se generaron {creadas} liquidaciones (si faltaban).")
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

    pdf_bytes = render_to_pdf("liquidacion_pdf.html", {
        "liquidacion": liquidacion,
    })

    if pdf_bytes is None:
        return HttpResponse("Error al generar el PDF", status=500)

    filename = f"liquidacion_{liquidacion.empleado.rut}_{liquidacion.periodo}.pdf"

    response = HttpResponse(pdf_bytes, content_type="application/pdf")
    response["Content-Disposition"] = f'attachment; filename="{filename}"'

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
