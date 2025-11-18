from django import forms
from .models import Empleado
from datetime import date
from .models import SolicitudVacacional
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

class SolicitudVacacionalForm(forms.ModelForm):
    class Meta:
        model = SolicitudVacacional
        fields = ['fecha_inicio', 'fecha_fin']
        widgets = {
            'fecha_inicio': forms.DateInput(attrs={'type': 'date', 'required': True}),
            'fecha_fin': forms.DateInput(attrs={'type': 'date', 'required': True}),
        }
        labels = {
            'fecha_inicio': 'Fecha de inicio',
            'fecha_fin': 'Fecha de fin',
        }
    
    def clean(self):
        cleaned_data = super().clean()
        fecha_inicio = cleaned_data.get('fecha_inicio')
        fecha_fin = cleaned_data.get('fecha_fin')
        
        if fecha_inicio and fecha_fin:
            if fecha_fin < fecha_inicio:
                raise forms.ValidationError("La fecha de fin no puede ser anterior a la fecha de inicio.")
            
            # Calcular días automáticamente
            dias_calculados = (fecha_fin - fecha_inicio).days + 1
            cleaned_data['dias'] = dias_calculados
            
            if dias_calculados > 15:
                raise forms.ValidationError(f"El rango de fechas equivale a {dias_calculados} días, pero el máximo permitido es 15.")
        
        return cleaned_data