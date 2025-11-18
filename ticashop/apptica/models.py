from django.db import models
from django.core.exceptions import ValidationError
from decimal import Decimal


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
    ESTADOS = [
        ('PENDIENTE', 'Pendiente'),
        ('APROBADA', 'Aprobada'),
        ('RECHAZADA', 'Rechazada'),
    ]
    
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    dias = models.IntegerField()
    estado = models.CharField(max_length=20, choices=ESTADOS, default='PENDIENTE')
    fecha_solicitud = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Solicitud {self.id} - {self.empleado.nombre}"



# ====== Liquidaciones ======
class Liquidacion(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    periodo = models.DateField(help_text="Usa el primer día del mes, ej: 2025-11-01")
    monto_total = models.DecimalField(max_digits=14, decimal_places=2)
    estado = models.CharField(max_length=20, choices=ESTADO_LIQ, default="PENDIENTE_FIRMA")
    pdf = models.FileField(upload_to="liquidaciones/", blank=True, null=True)
    comisiones = models.DecimalField(
        max_digits=14,
        decimal_places=2,
        default=0,
        blank=True,
        null=True,
    )
    
    # NUEVOS CAMPOS PARA FIRMA DIGITAL
    firma_empleado = models.ImageField(upload_to='firmas/', null=True, blank=True)
    fecha_firma = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"Liquidación {self.empleado.nombre} · {self.periodo}"



# ====== Comisiones ======

class ComisionVenta(models.Model):
    empleado = models.ForeignKey('Empleado', on_delete=models.CASCADE)
    periodo = models.DateField()
    ventas_totales = models.DecimalField(max_digits=14, decimal_places=2, default=0)

    # 👇 la columna existe en la BD, pero la vamos a rellenar nosotros
    comision = models.DecimalField(
        max_digits=14,
        decimal_places=2,
        default=0,
        blank=True,
        null=True,   # permite que llegue vacía desde phpMyAdmin
    )

    estado = models.CharField(max_length=20, default="CALCULADA", blank=True)

    COMISION_PORCENTAJE = Decimal("0.015")  # 1,5%

    def save(self, *args, **kwargs):
        # si no hay ventas_totales, dejamos 0
        if self.ventas_totales is None:
            self.ventas_totales = Decimal("0")

        # 💡 AQUÍ va tu fórmula:
        # comision = ventas_totales * 0.015
        self.comision = self.ventas_totales * self.COMISION_PORCENTAJE

        if not self.estado:
            self.estado = "CALCULADA"

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.empleado} · {self.periodo} · ventas={self.ventas_totales} · com={self.comision}"



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



# ====== Ventas ======

class Venta(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    fecha = models.DateField()
    monto = models.DecimalField(max_digits=14, decimal_places=2)
    

