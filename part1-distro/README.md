# Parte 1 — Distro Personalizada con Cubic

**Integrante responsable:** Esteban Trujillo
**Proyecto:** Proyecto Integrador — Sistemas Operativos / Linux (UIDE)

---

## 1. Nombre de la distro y base utilizada

- **Nombre de la distro:** LinuxDistro2026
- **Linux base:** Ubuntu 24.04.4 LTS (Desktop, amd64)
- **Herramienta de construcción:** Cubic (Custom Ubuntu ISO Creator)
- **Compresión de la ISO:** XZ

---

## 2. Modificaciones realizadas (con justificación)

### 2.1. Firefox ESR (en lugar de LibreWolf)

La modificación originalmente planeada era instalar **LibreWolf** como navegador alternativo. Sin embargo, durante el proceso de construcción el repositorio oficial de LibreWolf (`deb.librewolf.net`) devolvió un **error 404** al intentar descargar el paquete para esta versión de Ubuntu, lo que impidió completar la instalación dentro del entorno chroot de Cubic.

Como alternativa funcional y justificada, se instaló **Firefox ESR (Extended Support Release)**, que cumple el mismo propósito de ofrecer una opción de navegador distinta a la que trae Ubuntu por defecto (Firefox vía Snap), con un ciclo de soporte extendido orientado a estabilidad.

- Versión confirmada: `Mozilla Firefox 140.12.0esr`
- Verificación por terminal: `firefox-esr --version`
- Verificación visual: menú **Help → About Firefox**, que muestra explícitamente "Extended Support Release" y el sufijo `esr` en el número de versión — confirmando que es distinto al Firefox Snap preinstalado en Ubuntu.

> **Nota técnica:** en el entorno de prueba (VM anidada en VirtualBox), tanto `firefox-esr` como `code` requieren el flag `--no-sandbox` para abrir su interfaz gráfica. Esto se debe a que el sandbox de Chromium/Electron necesita crear *user namespaces*, los cuales el kernel del hipervisor restringe en esta configuración de virtualización anidada (`CanCreateUserNamespace() failure: EACCES`). Esto no representa un fallo de la instalación, sino una limitación conocida del entorno de prueba.

### 2.2. Visual Studio Code

Se instaló Visual Studio Code como entorno de desarrollo integrado, dada su relevancia para tareas de programación dentro del curso.

- Versión confirmada: `1.125.1`
- Verificación por terminal: `code --version`
- Verificación visual: apertura completa de la interfaz (menús File/Edit/Selection/View/Go/Run, panel de Chat/Agent funcional).

### 2.3. Personalización de `/etc/skel`

Se modificó `/etc/skel` para que todo usuario nuevo creado en el sistema herede automáticamente:

- Un **prompt de terminal en color verde**, con el formato `usuario@distrogrupo:~$`
- Alias personalizados: `actualizar` (equivalente a `sudo apt update && sudo apt upgrade`) y `limpiar` (equivalente a `sudo apt autoremove && sudo apt autoclean`)

Esta es una personalización **persistente**, ya que queda incorporada en la plantilla de creación de usuarios del sistema, no en la sesión activa únicamente.

---

## 3. Enlace de descarga de la ISO

📦 **Descargar ISO:** [PENDIENTE — pegar aquí el link de Google Drive o MEGA]

> La ISO no se incluye en este repositorio de GitHub debido a su tamaño (5.68 GiB), que excede el límite permitido por GitHub.

- Archivo: `ubuntu-24.04.4-2026.06.19-desktop-amd64.iso`
- Tamaño: 5.68 GiB

---

## 4. Hash MD5

```
933eae0bc079cb658d0ae42e78521777
```

Generado automáticamente por Cubic durante el proceso de creación de la ISO. Verificar tras la descarga con:

```bash
md5sum ubuntu-24.04.4-2026.06.19-desktop-amd64.iso
```

El resultado debe coincidir exactamente con el hash anterior para confirmar que la descarga no se corrompió.

---

## 5. Instrucciones para bootear la ISO

### En VirtualBox

1. Crear una nueva VM: **Nuevo** → Tipo: Linux, Versión: Ubuntu (64-bit)
2. Memoria RAM recomendada: **4096 MB** (mínimo 2048 MB)
3. En **Configuración → Almacenamiento**, montar el archivo `.iso` descargado en el controlador IDE/SATA (unidad óptica)
4. En **Configuración → Sistema → Placa base**, confirmar que la unidad óptica esté habilitada y priorizada en el **orden de arranque**, antes del disco duro
5. Iniciar la VM. En el menú de GRUB, seleccionar **"Try or Install Ubuntu"**
6. Esperar a que cargue el escritorio en vivo

### En QEMU

```bash
qemu-system-x86_64 \
  -m 4096 \
  -cdrom ubuntu-24.04.4-2026.06.19-desktop-amd64.iso \
  -boot d \
  -enable-kvm
```

---

## 6. Capturas de pantalla

Ubicadas en `screenshots/`:

| Archivo | Descripción |
|---|---|
| `boot.png` | Escritorio de bienvenida tras el arranque de la ISO |
| `desktop-firefox-esr.png` | Ventana "About Firefox" confirmando Extended Support Release, versión 140.12.0esr |
| `vscode.png` | Visual Studio Code abierto y funcional |
| `terminal-prompt.png` | Terminal mostrando el prompt verde personalizado `usuario@distrogrupo:~$` |

---

## 🎥 Video de demostración

📺 **Ver video:** [PENDIENTE — pegar aquí el link del video, ≤5 minutos]

El video muestra en vivo, en orden:
1. Arranque de la ISO (boot hasta escritorio)
2. Apertura de Firefox ESR, confirmando que no es el Firefox normal
3. Apertura de Visual Studio Code
4. Terminal con el prompt personalizado en verde

---

## Estructura de este directorio

```
part1-distro/
├── README.md
├── checksum.md5
└── screenshots/
    ├── boot.png
    ├── desktop-firefox-esr.png
    ├── vscode.png
    └── terminal-prompt.png
```
