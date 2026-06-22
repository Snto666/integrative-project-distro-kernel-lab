# Part 3: Black Hat Bash Laboratory Deployment and Reconnaissance

**Responsible Student:** Daniel  
**Academic Period:** March - July 2026  
**Institution:** International University of Ecuador (UIDE)  

---

## 1. Network and Docker Environment Configuration

The environment was successfully deployed on an Ubuntu 22.04 LTS host using Docker and Docker Compose V2 via the `sudo make deploy` command.

### Local Network Interface Mapping
* **Public Network (`br_public`):** `172.16.10.0/24` (Host IP: `172.16.10.1`)
* **Corporate Network (`br_corporate`):** `10.1.0.0/24` (Host IP: `10.1.0.1`)

### Container Inventory and IP Addressing
| Container | Assigned Networks | IP Address(es) | State |
| :--- | :--- | :--- | :--- |
| `p-web-01` | Public | `172.16.10.10` | Active |
| `p-ftp-01` | Public | `172.16.10.11` | Active |
| `p-web-02` | Public / Corporate | `172.16.10.12` / `10.1.0.11` | Active |
| `p-jumpbox-01` | Public / Corporate | `172.16.10.13` / `10.1.0.12` | Active |
| `c-backup-01` | Corporate | `10.1.0.13` | Active |
| `c-redis-01` | Corporate | `10.1.0.14` | Active |
| `c-db-01` | Corporate | `10.1.0.15` | Active |
| `c-db-02` | Corporate | `10.1.0.16` | Active |

---

## 2. Executed Reconnaissance Techniques

### A. Port and Service Scanning (Nmap)
A fast service version detection scan (`nmap -sV -F`) was executed against the public segment, yielding the following discoveries:

* **`172.16.10.10` (p-web-01):** Port `8081/tcp` open, running a **Werkzeug 3.0.1 (Python 3.12.3)** development server.
* **`172.16.10.11` (p-ftp-01):** Port `21/tcp` open (**vsftpd 3.0.5**) and Port `80/tcp` open (**Apache httpd 2.4.58**).
* **`172.16.10.12` (p-web-02):** Port `80/tcp` open (**Apache httpd 2.4.57** on Debian).
* **`172.16.10.13` (p-jumpbox-01):** Port `22/tcp` open (**OpenSSH 9.6p1**).

### B. Web Technology Fingerprinting and FTP Connectivity
* HTTP response headers from the Werkzeug server on port `8081` were captured and analyzed.
* File transfer capabilities on the public FTP server (`p-ftp-01`) were validated using automated `curl` requests.

---

## 3. System Verification Evidence

```bash
# Control output verifying active containers within Daniel's environment:
p-web-02        Up 3 minutes
p-web-01        Up 3 minutes
p-jumpbox-01    Up 3 minutes
p-ftp-01        Up 3 minutes
4. Technical Interpretations and Proof of Concept
This section covers the validation of the lab environment through control commands, network inspection, and offensive reconnaissance using screen captures recorded on the host system.

Evidence 1: Virtual Network Interface Mapping
Command: ip addr | grep "br_"

File Path: screenshots/ip-addr.jpg

Technical Interpretation:
This command isolates the custom network bridge interfaces spawned by Docker Compose. The output confirms that br_public is correctly bound to 172.16.10.1/24 and br_corporate to 10.1.0.1/24. This structural segmentation enforces tight perimeter isolation, ensuring no malicious traffic leaks out into external networks or the official UIDE campus network.

Evidence 2: Container Interactivity and Shell Access
Command: sudo docker exec -it p-web-01 bash

File Path: screenshots/docker-exec.jpg

Technical Interpretation:
This step proves local administrative control from the host machine into the containerized namespace using an interactive /bin/bash session. Successfully executing internal commands (ls followed by exit) indicates that the target container is healthy, responsive, and available for internal auditing.

Evidence 3: Active Service Reconnaissance (Nmap)
Command: nmap -sV -F 172.16.10.10

File Path: screenshots/nmap-scan.jpg

Technical Interpretation:
The fast port scan mapped port 8081/tcp as open on the public-facing target. Service fingerprinting identified the underlying framework as Werkzeug 3.0.1 (Python 3.12.3). Leaving a raw development server exposed constitutes a critical configuration weakness; these utilities lack robust security hardening and often ship with interactive debugging tools that can be weaponized for Remote Code Execution (RCE).

Evidence 4: Web Stack Fingerprinting (WhatWeb)
Command: whatweb http://172.16.10.10:8081

File Path: screenshots/whatweb-scan.jpg

Technical Interpretation:
By analyzing the raw HTTP transmission, critical metadata tags were extracted, confirming a Python-driven backend. Explicitly leaking granular software versions (Werkzeug/3.0.1, Python/3.12.3) unnecessarily broadens the attack surface, giving malicious actors the precise details needed to look up known exploits and public vulnerabilities (CVEs) tailored to this stack.
