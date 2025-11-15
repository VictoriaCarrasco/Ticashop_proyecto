from django import forms
from .models import Empleado

class EmpleadoForm(forms.ModelForm):
    class Meta:
        model = Empleado
        fields = ["nombre", "email", "rut", "rol", "departamento", "activo"]
        labels = {
            "nombre": "Nombre y apellidos",   # 👈 cambia la etiqueta que verá el usuario
        }
        widgets = {
            "nombre": forms.TextInput(attrs={"class": "input"}),
            "email": forms.EmailInput(attrs={"class": "input"}),
            "rut": forms.TextInput(attrs={"class": "input"}),
            "rol": forms.Select(attrs={"class": "select"}),
            "departamento": forms.Select(attrs={"class": "select"}),
            "activo": forms.CheckboxInput(attrs={"class": "checkbox"}),
        }
