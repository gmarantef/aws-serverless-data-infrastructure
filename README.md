<h1>aws-serverless-data-infrastructure</h1>

Repositorio que tiene como objetivo la consecución de los siguientes puntos:

- Construir un entorno de desarrollo para infraestructura como código (IaC)
  en AWS haciendo uso del lengiaje HCL y el frameowrk OpenTofu.
- Reusabilidad del espacio de desarrollo con contenerización mediante Docker,
  Docker Compose y Devcontainer.
- Construcción de entorno DEV (development) con Localstack para desarrollo ágil
  de infraestructura sin costes asociados y testing.
- Despliegues automatizados en los entornos PRO, PRE y DEV mediante pipelines
  CI/CD con GitHub Actions.
- Arquitectura básica para procesamiento de datos en AWS mediante servicios
  serverless.

<h2>Índice</h2>

- [Entorno de desarollo](#entorno-de-desarollo)
  - [localstack service](#localstack-service)
  - [opentofu service](#opentofu-service)
  - [netowrking](#netowrking)
  - [setup](#setup)
- [OpenTofu configuration](#opentofu-configuration)

## Entorno de desarollo

Para la creación del entorno de desarrollo se emplean docker-compose junto con
devcontainer para permitir definir los servicios de Localstack y de OpenTofu
y usar el segundo como entorno de desarrollo en VSCode.

### localstack service

El servicio de localstack se emplea para gestionar el contenedor donde el
framework [LocalStack](https://www.localstack.cloud/) pueda generar la
infraestructura de recursos deseada en AWS y poder ser ejcutada para debugueo
y testing dentro de este.

### opentofu service

El servicio de opentofu brinda el espacio de desarrollo para la infraestructura
como código haciendo uso del
[AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
y operando con el framework [OpenTofu](https://opentofu.org/) para evitar la
[Terraform License](https://github.com/hashicorp/terraform/blob/main/LICENSE)
aunque en el presente proyecto no se vea afectado por esta.

La instalación del framework en el contenedor se realiza mediante el Dockerfile
para evitar usar features no conocidas y poder emplear la imágen mínima
requerida por el setup y empleando multi stage builds optimizar el build.

### netowrking

Los dos servicios anteriores comparten network para permitir al de opentofu
comunicarse con el de localstack para desplegar la infra en este.

### setup

Adicionalmente y para definir un setup de desarrollo cómodo, sobre el servicio
de opentofu haciendo uso de la tecnología devcontainer se incluyen una serie
de extensiones básicas y se ajusta el modo editor del IDE.

## OpenTofu configuration