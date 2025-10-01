# mi_agenda

Aplicación Flutter sencilla para gestionar contactos.

## Descripción

**mi_agenda** es una app de ejemplo para gestionar contactos, con login de demostración, listado con búsqueda y alta de contactos usando Provider para la gestión de estado.

## Funcionalidades

- **Login de demostración**
    - Usuario: `admin@mail`
    - Contraseña: `123456`
- **Listado de contactos**
    - Visualización en lista
    - Búsqueda en tiempo real por nombre, apellido, teléfono o email
- **Alta de contacto**
    - Campos: Nombre, Apellido, Teléfono, Email, Dirección, Fecha de nacimiento
    - Validaciones básicas e input formatters
    - Avatar con iniciales si no hay imagen
- **Tema oscuro**
- **Estilos globales** para AppBar, Inputs y Botones
- **Logout**
- **Persistencia:** en memoria (no se guarda al cerrar la app)

## Estructura del proyecto

```
lib/
├─ app_theme.dart
├─ main.dart
├─ models/
│  └─ contact.dart
├─ providers/
│  ├─ auth_provider.dart
│  └─ contacts_provider.dart
├─ screens/
│  ├─ login_screen.dart
│  ├─ contacts_screen.dart
│  └─ contact_form_screen.dart
└─ widgets/
     └─ login_form.dart
```

## Primeros pasos

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar en un dispositivo/emulador:

```bash
flutter run
```

Opcional: Builds

```bash
# Android
flutter build apk

# iOS (desde macOS)
flutter build ios
```

---

Desarrollado como ejemplo para prácticas de Flutter y Provider. 
