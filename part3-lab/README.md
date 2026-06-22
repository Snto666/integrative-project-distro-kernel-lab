# Parte 3: Despliegue de Laboratorio Black Hat Bash y Reconocimiento

**Estudiante Responsable:** Daniel
**Período Académico:** Marzo - Julio 2026
**Institución:** Universidad Internacional del Ecuador (UIDE)

---
## 1. Configuración del Entorno de Red y Docker

El entorno se desplegó de manera exitosa sobre un host con Ubuntu 22.04 LTS utilizando Docker y Docker Compose V2 mediante el comando `sudo make deploy`.

### Mapeo de Interfaces de Red Locales
* **Red Pública (`br_public`):** `172.16.10.0/24` (IP Host: `172.16.10.1`)
* **Red Corporativa (`br_corporate`):** `10.1.0.0/24` (IP Host: `10.1.0.1`)

### Inventario de Contenedores y Direccionamiento IP
| Contenedor | Redes Asignadas | IP(s) | Estado |
| :--- | :--- | :--- | :--- |
| `p-web-01` | Public | `172.16.10.10` | Activo |
| `p-ftp-01` | Public | `172.16.10.11` | Activo |
| `p-web-02` | Public / Corporate | `172.16.10.12` / `10.1.0.11` | Activo |
| `p-jumpbox-01` | Public / Corporate | `172.16.10.13` / `10.1.0.12` | Activo |
| `c-backup-01` | Corporate | `10.1.0.13` | Activo |
| `c-redis-01` | Corporate | `10.1.0.14` | Activo |
| `c-db-01` | Corporate | `10.1.0.15` | Activo |
| `c-db-02` | Corporate | `10.1.0.16` | Activo |

---
## 2. Técnicas de Reconocimiento Ejecutadas

### A. Escaneo de Puertos y Servicios (Nmap)
Se lanzó un escaneo de detección de versiones (`nmap -sV -F`) contra el segmento público, obteniendo los siguientes hallazgos:

* **`172.16.10.10` (p-web-01):** Puerto `8081/tcp` abierto ejecutando servidor de desarrollo **Werkzeug 3.0.1 (Python 3.12.3)**.
* **`172.16.10.11` (p-ftp-01):** Puerto `21/tcp` (**vsftpd 3.0.5**) y Puerto `80/tcp` (**Apache httpd 2.4.58**).
* **`172.16.10.12` (p-web-02):** Puerto `80/tcp` (**Apache httpd 2.4.57** en Debian).
* **`172.16.10.13` (p-jumpbox-01):** Puerto `22/tcp` (**OpenSSH 9.6p1**).

### B. Análisis de Tecnologías Web y Conectividad FTP
* Se identificaron las cabeceras del servidor Werkzeug en el puerto `8081`.
* Se comprobó la transferencia de archivos en el servidor FTP público (`p-ftp-01`) mediante solicitudes automatizadas `curl`.

---
## 3. Evidencia de Verificación del Sistema
```bash
# Salida de control de contenedores activos en el entorno de Daniel:
p-web-02       Up 3 minutes
p-web-01       Up 3 minutes
p-jumpbox-01   Up 3 minutes
p-ftp-01       Up 3 minutes
```

## 3. Evidencias de Verificación e Interpretación Técnica

A continuación se detalla la validación del entorno del laboratorio mediante la ejecución de comandos de control, inspección de red y análisis ofensivo, utilizando los registros de captura generados en el sistema host.

---

### 📸 Evidencia 1: Mapeo de Interfaces de Red Virtuales
* **Comando:** `ip addr | grep "br_"`
* **Archivo:** `screenshots/iloveimg-converted/PARTE1.jpg`

#### Interpretación Técnica:
El comando filtra las interfaces de tipo puente (*bridge*) creadas por Docker Compose. Se verifica que `br_public` se encuentra asociada al direccionamiento `172.16.10.1/24` y `br_corporate` al direccionamiento `10.1.0.1/24`. Este esquema garantiza el aislamiento perimetral del laboratorio, impidiendo la fuga de tráfico malicioso hacia la red externa o universitaria de la UIDE.

---

### 📸 Evidencia 2: Interactividad y Acceso Local a Contenedores
* **Comando:** `sudo docker exec -it p-web-01 bash`
* **Archivo:** `screenshots/iloveimg-converted/PARTE2.jpg`

#### Interpretación Técnica:
Se demuestra la capacidad de evasión local y control administrativo del Host sobre el espacio de nombres del contenedor mediante una shell interactiva `/bin/bash`. La ejecución exitosa de los comandos internos (`ls` y `exit`) confirma que el contenedor se encuentra responsivo para auditorías internas.

---

### 📸 Evidencia 3: Reconocimiento Activo de Servicios (Nmap)
* **Comando:** `nmap -sV -F 172.16.10.10`
* **Archivo:** `screenshots/iloveimg-converted/PARTE3.jpg`

#### Interpretación Técnica:
El escaneo rápido de puertos detectó el puerto `8081/tcp` abierto en el objetivo público. El *fingerprinting* identificó el servicio **Werkzeug 3.0.1 (Python 3.12.3)**. El hallazgo de un servidor de desarrollo expuesto representa una severa debilidad de configuración, debido a que estos servicios carecen de mecanismos robustos de hardening y suelen incluir consolas de depuración interactivas que facilitan la ejecución remota de código (RCE).

---

### 📸 Evidencia 4: Fingerprinting del Stack Web (WhatWeb)
* **Comando:** `whatweb http://172.16.10.10:8081`
* **Archivo:** `screenshots/iloveimg-converted/PARTE4.jpg`

#### Interpretación Técnica:
El análisis de peticiones extrajo metadatos técnicos críticos de las cabeceras HTTP, corroborando el uso de Python. La exposición explícita de las versiones de software (`Werkzeug/3.0.1`, `Python/3.12.3`) incrementa la superficie de ataque, permitiendo mapear vectores de explotación específicos contra la aplicación a través de bases de datos públicas de vulnerabilidades (CVEs).
