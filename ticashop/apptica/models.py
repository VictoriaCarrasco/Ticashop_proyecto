from django.db import models
from django.core.exceptions import ValidationError


# ====== Catálogos simples ======
ROLES = [
    ("ADMIN", "Admin"),
    ("RRHH", "RRHH"),
    ("NOMINA", "Nómina"),
    ("JEFATURA", "Jefatura"),
    ("SUP_COM", "Supervisor Comercial"),
    ("TECNICO", "Técnico"),
    ("GENERAL", "General"),
]

DEPARTAMENTOS = [
    ("RRHH", "Recursos Humanos"),
    ("OPERACIONES", "Operaciones"),
    ("VENTAS", "Ventas"),
    ("FINANZAS", "Finanzas"),
    ("OTRO", "Otro"),
]

ESTADO_VAC = [("PENDIENTE", "Pendiente"), ("APROBADA", "Aprobada"), ("RECHAZADA", "Rechazada")]
ESTADO_LIQ = [("PENDIENTE_FIRMA", "Pendiente Firma"), ("FIRMADA", "Firmada")]
ESTADO_COM = [("PENDIENTE", "Pendiente"), ("CALCULADA", "Calculada")]
ESTADO_ASI = [("PRESENTE", "Presente"), ("AUSENTE", "Ausente"), ("TARDANZA", "Tardanza")]


# ====== Usuarios (empleados del sistema) ======
class Empleado(models.Model):
    nombre = models.CharField(max_length=120)
    email = models.EmailField(unique=True)
    rut = models.CharField(max_length=12, unique=True)
    rol = models.CharField(max_length=20, choices=ROLES, default="GENERAL")
    departamento = models.CharField(max_length=20, choices=DEPARTAMENTOS, default="OTRO")
    activo = models.BooleanField(default=True)

    # opcional: saldo simple para vacaciones
    saldo_vacaciones_dias = models.PositiveIntegerField(default=0)

    def __str__(self):
        return f"{self.nombre} · {self.rol}"


# ====== Vacaciones ======
class SolicitudVacacional(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    dias = models.PositiveIntegerField(default=0)          # puedes llenarlo a mano o calcular en la vista
    estado = models.CharField(max_length=10, choices=ESTADO_VAC, default="PENDIENTE")
    observacion = models.TextField(blank=True)

    def __str__(self):
        return f"Vacaciones de {self.empleado.nombre} ({self.estado})"


# ====== Liquidaciones ======
class Liquidacion(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    periodo = models.DateField(help_text="Usa el primer día del mes, ej: 2025-10-01")
    monto_total = models.DecimalField(max_digits=14, decimal_places=2)
    estado = models.CharField(max_length=20, choices=ESTADO_LIQ, default="PENDIENTE_FIRMA")
    pdf = models.FileField(upload_to="liquidaciones/", blank=True, null=True)  # para “Descargar PDF”

    def __str__(self):
        return f"Liquidación {self.empleado.nombre} · {self.periodo}"


# ====== Comisiones ======
class ComisionVenta(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    periodo = models.DateField()
    ventas_totales = models.DecimalField(max_digits=16, decimal_places=2, default=0)
    comision = models.DecimalField(max_digits=16, decimal_places=2, default=0)
    estado = models.CharField(max_length=10, choices=ESTADO_COM, default="PENDIENTE")

    def __str__(self):
        return f"Comisión {self.empleado.nombre} · {self.periodo}"


# ====== Asistencia ======
class RegistroAsistencia(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    fecha = models.DateField()
    hora_entrada = models.TimeField(blank=True, null=True)
    hora_salida = models.TimeField(blank=True, null=True)
    estado = models.CharField(max_length=10, choices=ESTADO_ASI, default="PRESENTE")

    def clean(self):
        for nombre, t in (("hora_entrada", self.hora_entrada), ("hora_salida", self.hora_salida)):
            if t and not (0 <= t.hour <= 23):
                raise ValidationError({nombre: "La hora debe estar entre 00:00 y 23:59."})

    def __str__(self):
        return f"Asistencia {self.empleado.nombre} · {self.fecha} · {self.estado}"