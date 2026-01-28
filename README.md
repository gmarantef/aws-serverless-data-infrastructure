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
- [Terraform configuration](#terraform-configuration)
  - [Recursos desplegados](#recursos-desplegados)
- [Terraform environments](#terraform-environments)

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

## Terraform configuration

La configuración de Terraform la componen principalmente los siguientes
ficheros:

- terraform.tf -> donde se define la versión requerida y la instancia para el
  provider de AWS.
- provider.tf -> donde se configura la instancia del provider de AWS creada.
  - se mokean las credenciales de acceso a cuenta ya que se usa con LocalStack.
  - se skipean la validación de credenciales y las request al account ID para
    evitar problemas con STS.
  - se apuntan los servicios al CONTAINER_PORT del service de localstack

> Pese a hablar de la configuración de Terraform en todo momento, el despliegue
> de la infraestructura se realiza haciendo uso del framework OpenTofu y por
> ende de sus comendos asociados, ya que este framework hereda la configuración
> de Terraform.

### Recursos desplegados

Para la validación y consulta de los recursos deplegados se accede a la
plataforma que el framework LocalStack provee tras previo registro gratuito
[LocalStack Platform](https://app.localstack.cloud/inst/default/resources/ec2/instances)
y desde donde se pueden ver accediendo a la instancia creada desde el localhost
en https://localhost.localstack.cloud:4566

## Terraform environments

Terraform dispone de la funcionalidad de definir Workspaces con los que
permitir cambiar entre entornos mediante consola y que la lógica de despliegue
de la infraestructura recaiga en el Workspace seleccionado.

Pero estos Workspaces son demasido rígidos, no permiten la definición de
backends distintos entre entornos (cosa que no es deseada pero no dan
siquiera la opción) y si no se usan Clouds remotos que permitan trabajar
directamente con los Workspaces (se nota que están pensados para operar muy
bien con Terraform Cloud) pueden generar más inconvenientes que facilidades
como imposibilidad de definir restricciones en los apply según entorno.

Por ello, para la generación de los entornos aislados de dev, pre y pro se
adopta la solución de aislarlos entre sí en distintas carpetas y que el punto
común de ellos sea la infraestructura definida en módulos compartidos.
Permitiendo así el desarrollo de nuevos módulos de forma ágil en el entorno
dev desplegando en LocalStack los módulos involucrados en la arquitectura
desarrollada, y disponiendo de los entornos pre y pro separados por la capa
lógica que permite introducir diferencias entre ellos como cuando tener activos
los lanzamientos automáticos de procesos como ejemplo.

```
infra/
├── dev/
|   └── backend.tf
│   └── main.tf
|   └── providers.tf
|   └── terraform.tf
│
├── pre/
|   └── backend.tf
|   └── config.remote.tfbackend
│   └── main.tf
|   └── providers.tf
|   └── terraform.tf
│
├── pro/
|   └── backend.tf
|   └── config.remote.tfbackend
│   └── main.tf
|   └── providers.tf
|   └── terraform.tf
│
└── modules/
```
