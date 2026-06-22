Markdown

# Part 3: Black Hat Bash Laboratory Deployment and Security Assessment

## Project Overview
This documentation covers the successful deployment, verification, and active security audit of the containerized enterprise laboratory infrastructure. Operating from an Ubuntu host environment, the primary focus of this phase was to initialize a segmented infrastructure consisting of 8 specific containers, map the virtual interfaces, and execute authorized reconnaissance techniques to identify the architecture's attack surface.

---

## Phase 1: Laboratory Deployment and Verification

### 1. Environment Initialization
The multi-container testing infrastructure was instantiated from the local workspace directory by running the automated framework:
```bash
cd ~/Black-Hat-Bash/lab
sudo make deploy

Technical Purpose: This script handles the automated configuration of virtual networks and fetches the specified software microservices to build the structured topology.
2. Service Readiness and Container Verification

To guarantee complete system availability and integration across all simulated nodes, the deployment state was verified using the platform utility checks:
Bash

sudo make test

Expected Output: Lab is up.

Following verification, the running instances were enumerated to confirm the presence of all 8 primary containers:
Bash

sudo docker ps --format "{{.Names}}"

Validated Container Nodes:

    p-web-01 & p-web-02 (Public Web Servers)

    p-ftp-01 (Public FTP Server)

    p-router-01 (Inter-network Logical Router)

    c-db-01 (Corporate Database Server)

    c-cms-01 (Corporate Content Management System)

    c-dev-01 (Internal Development Server)

    c-backup-01 (Internal Backup Node)

3. Logical Network Interface Mapping

The host network subsystem was inspected to validate that logical isolation parameters were successfully established across the separate software bridges:
Bash

ip addr | grep "br_"

Identified Network Interfaces:

    br_public (IP: 172.16.10.1): Manages the public-facing demilitarized perimeter.

    br_corporate (IP: 10.1.0.1): Encloses and isolates confidential corporate assets.

Phase 2: Laboratory Architecture Matrix

The following operational layout defines the localized logical routing parameters extracted using the docker inspect engine:
Container	Public IP	Corporate IP	Infrastructure Role
p-web-01	172.16.10.10	—	Perimeter Public Web Server
p-web-02	172.16.10.11	—	Secondary Public Web Server
p-ftp-01	172.16.10.21	—	Public FTP Service Node
p-router-01	172.16.10.1	10.1.0.1	Logical Gateway / Core Router
c-db-01	—	10.1.0.10	Internal Relational Database
c-cms-01	—	10.1.0.20	Corporate Portal Content Manager
c-dev-01	—	10.1.0.30	Internal Software Development Environment
c-backup-01	—	10.1.0.40	Secure System Backup Repository
Phase 3: Reconnaissance and Active Auditing Techniques
Technique 1: Network Service Enumeration via Nmap

    Description: Performs active port interrogation against the primary perimeter container to discover active sockets, bound services, and application banner definitions.

    Execution Command:

Bash

nmap -sV -sC 172.16.10.10

    Analysis and Technical Interpretation: This scan maps the perimeter's visible attack surface by probing for open communication channels (e.g., port 80/tcp running HTTP). Identifying exact service software variations allows an auditor to systematically assess whether the exposed asset is susceptible to public exploits or misconfigurations.

Technique 2: Web Application Fingerprinting via WhatWeb

    Description: Analyzes HTTP application layer responses from the web entry point to identify underlying web servers, application frameworks, scripting engines, and content management systems.

    Execution Command:

Bash

whatweb [http://172.16.10.10](http://172.16.10.10)

    Analysis and Technical Interpretation: This utility extracts passive metadata signatures from the response headers and page structures. By exposing precise tech-stack elements (such as explicit web server engines like Apache or Nginx, or framework distributions like WordPress), it eliminates guesswork, giving an auditor clear insights into target components.

Technique 3: Anonymous File Transfer Protocol (FTP) Audit

    Description: Tests the ingress authentication configuration of the perimeter storage server to determine if unauthenticated access is permitted using default anonymous credentials.

    Execution Command:

Bash

ftp 172.16.10.21

(Input anonymous when prompted for the username and press Enter at the password prompt).

    Analysis and Technical Interpretation: This procedure evaluates access control enforcement. If a successful login is achieved without cryptographic validation, it highlights a critical misconfiguration exposing the file directory structure. This allows unauthorized data extraction or file manipulation within the public segment.

Conclusion

The implementation of the Part 3 laboratory successfully demonstrates infrastructure virtualization and defensive perimeter auditing. Establishing distinct software bridges (br_public and br_corporate) effectively secures backend resources from external interference. The deployment and subsequent auditing exercises validate both proper microservice segregation and the execution of industry-standard offensive security assessment utilities within an isolated testing environment.
