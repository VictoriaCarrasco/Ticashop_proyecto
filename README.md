# TicaShop · Sistema de Gestión de RR.HH. y Remuneraciones

Plataforma web en Django para gestionar empleados, vacaciones, asistencia, comisiones por ventas y liquidaciones de sueldo con firma digital y exportación a PDF.

---

## 📋 Descripción

TicaShop es una aplicación web interna orientada a la gestión de personas en una empresa. Centraliza procesos que normalmente se manejan en planillas: solicitud y aprobación de vacaciones, control de asistencia, cálculo de comisiones de venta y emisión de liquidaciones de sueldo, que el trabajador firma digitalmente desde el navegador.

El acceso se basa en **roles** (Admin, RRHH, Nómina, Jefatura, Supervisor Comercial, Técnico, General), de modo que cada usuario ve y opera solo lo que le corresponde.

> Proyecto desarrollado en un contexto académico (evaluación de proyecto).

## ✨ Funcionalidades principales

- **Inicio de sesión con RUT y contraseña**, vinculado al usuario de Django por correo; hay una vista de login distinta para el panel de administración.
- **Control de acceso por roles** mediante un decorador propio (`validar_rol`).
- **Gestión de empleados y usuarios**: crear, editar, activar/desactivar y eliminar, con sueldo fijo asignado según el rol. Exportación a CSV.
- **Vacaciones**:
  - Solicitud con validación de fechas (la fecha de fin no puede ser anterior a la de inicio; máximo 15 días por solicitud; los días se calculan solos).
  - Aprobación o rechazo por RRHH/Admin, y restablecimiento de saldos.
  - Exportación a **Excel (.xlsx)**.
- **Asistencia**: registro de entrada y salida con estado (Presente, Ausente, Tardanza). Exportación a CSV.
- **Comisiones por ventas**: cálculo automático del **1,5 %** sobre las ventas totales del período. Exportación a Excel.
- **Liquidaciones de sueldo**:
  - Generación mensual, restringida al rol Nómina.
  - Incluye la comisión del mes y un descuento proporcional por ausencias.
  - **Firma digital** del trabajador: la firma se dibuja en el navegador y se guarda como imagen.
  - **Descarga en PDF** (xhtml2pdf).
- **Dashboard** con un resumen después de iniciar sesión.

## 🛠️ Stack tecnológico

| Capa | Tecnología |
|---|---|
| Backend | Python 3 · Django 5.2 |
| Base de datos | MySQL / MariaDB (conector `mysqlclient`) |
| PDF | xhtml2pdf |
| Excel | openpyxl |
| Frontend | Plantillas Django · HTML · CSS |
| Localización | `es-cl`, zona horaria `America/Santiago` |

## 📁 Estructura del proyecto

```
ticashop/
├── manage.py
├── ticashop/            # Configuración del proyecto (settings, urls, wsgi/asgi)
├── apptica/             # App principal
│   ├── models.py        # Empleado, SolicitudVacacional, Liquidacion, ComisionVenta, RegistroAsistencia, Venta
│   ├── views.py         # Lógica de negocio (vacaciones, liquidaciones, comisiones, asistencia, usuarios)
│   ├── forms.py
│   ├── decorators.py    # Control de acceso por rol
│   ├── context_processors.py
│   ├── admin_urls.py    # Rutas del panel de administración propio
│   ├── migrations/
│   ├── templates/       # Vistas HTML (incluye plantilla PDF de liquidación)
│   └── static/css/
├── media/               # Archivos subidos (firmas)
└── ticashop.sql         # Dump de la base de datos (MySQL/MariaDB)
```

## 🚀 Instalación local

> ⚠️ El repositorio **no incluye `requirements.txt`**. Las dependencias de abajo se dedujeron de los imports del código.

### 1. Clonar el repositorio
```bash
git clone https://github.com/VictoriaCarrasco/Ticashop_proyecto.git
cd Ticashop_proyecto/ticashop
```

### 2. Crear y activar un entorno virtual
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# macOS / Linux
source venv/bin/activate
```

### 3. Instalar dependencias (supuestas)
```bash
pip install "django>=5.2,<5.3" mysqlclient openpyxl xhtml2pdf
```

### 4. Configurar la base de datos (MySQL/MariaDB)
Crea la base de datos y un usuario:
```sql
CREATE DATABASE ticashop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'ticashop'@'localhost' IDENTIFIED BY 'tu_contraseña';
GRANT ALL PRIVILEGES ON ticashop.* TO 'ticashop'@'localhost';
```
Luego ajusta `DATABASES` en `ticashop/settings.py` con tus credenciales (se recomienda usar variables de entorno).

**Opción A – Importar el dump incluido** (trae estructura y datos de ejemplo):
```bash
mysql -u ticashop -p ticashop < ticashop.sql
```

**Opción B – Base limpia con migraciones:**
```bash
python manage.py migrate
```

### 5. Ejecutar el servidor
```bash
python manage.py runserver
```
Abre http://127.0.0.1:8000/. El login pide **RUT y contraseña** de un empleado activo, y ese empleado debe tener un usuario de Django con el mismo correo.

## 🖼️ Capturas de pantalla

> _Próximamente_

| Login | Dashboard | Liquidación PDF |
|---|---|---|
| ![Login](docs/screenshots/login.png) | ![Dashboard](docs/screenshots/dashboard.png) | ![Liquidación](docs/screenshots/liquidacion.png) |

## 🧭 Mejoras futuras

- Agregar `requirements.txt` y archivo `.env.example`; mover la clave secreta y las credenciales a variables de entorno.
- Proteger todas las vistas con autenticación y roles, y usar POST para las acciones destructivas.
- Hacer configurables el porcentaje de comisión y el sueldo base (hoy están fijos en el código).
- Pruebas automatizadas (unitarias e integración).
- Dashboard con gráficos e indicadores.
- Despliegue con Docker y configuración de producción (`DEBUG=False`, `ALLOWED_HOSTS`, archivos estáticos).
- Diseño responsive y mejoras de UX.

## 👩‍💻 Autora

**Victoria Carrasco**
GitHub: [@VictoriaCarrasco](https://github.com/VictoriaCarrasco)

¿Necesitas un sistema a medida para tu negocio? ¡Conversemos!
