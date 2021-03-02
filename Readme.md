# 1) Preparación previa

## Preparamos nuestro entorno para la configuración con Azure

### - Login Azure
Lanzamos el siguiente comando con el que se abrirá el navegador para poder iniciar sesión:
```
az login
```

### - Seteamos nuestro subscription ID
```
az account set --subscription={{ SUBSCRIPTION_ID }}
```
_Podemos encotnrarlo en la página "[Suscripciones](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade)" de Azure._

### - Creamos el servicio principal
```
az ad sp create-for-rbac --role="Contributor" -n "{{ NOMBRE_SERVICIO }}"
```

Esto nos devolverá la siguiente estructura cuyos datos necesitaremos para poder continuar con el despliegue:
```
	{
	  "appId": "APP_ID",
	  "displayName": "{{ NOMBRE_SERVICIO }}",
	  "name": "http://{{ NOMBRE_SERVICIO }}",
	  "password": "PASSWORD",
	  "tenant": "TENANT"
	}
```

### - Comandos útiles/necesarios durante el proceso
```
## Listar cuentas
az account list

## Listar el SP
az ad sp list --display-name {{ NOMBRE_SERVICIO }}

## Aceptar términos máquina (necesario una vez sepamos que tipos de máquinas vamos a utilizar). El siguiente comando es un ejemplo según la utilizada en la práctica.
az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810

```
## Generamos las claves ssh
Generamos las claves pública/privada para poder conectar desde el PC a las máquinas generadas. Por simplicidad en la práctica se ha decidido no generar passphrase:
```
ssh-keygen -t rsa
```

# 2) Terraform
## Directorio
Toda la configuración de terraform se encuenta en el directorio con el mismo nombre.

## Estructura
- credentials.tf: No se añade en el repositorio GitHub dado que contiene información sensible (Se añade en .gitignore)
- [main.tf](Terraform/main.tf): 
- [network.tf](Terraform/network.tf)
- [security.tf](Terraform/security.tf)
- [vars.tf](Terraform/vars.tf): Variable para poder utilizar en el resto de ficheros de configuración
- [vm.tf](Terraform/vm.tf): Contiene la configuración de las máquinas virtuales

## Pasos a seguir
### - Inicializar configuración
```
terraform init
```

### - Aplicar cambios y desplegar
```
terraform apply

## Si queremos que no nos pida confirmación podemos añadir el parámetro "--auto-approve"
``` 
>_Pedirá confirmación de los cambios que va a aplicar._

### - Eliminar la configuración indicada en los ficheros
```
terraform destroy
```
>_Pedirá confirmación de los cambios que va a aplicar._

# 3) Ansible
## Directorio
Toda la configuración de ansible se encuenta en el directorio con el mismo nombre.

## Estructura

## Pasos a seguir
### - Aplicamos la configuración común para todas las máquina
```
ansible-playbook -i hosts.yaml 1_ConfiguracionInicial.yml
```

### - Configuramos las particiones NFS compartidas entre las máquinas
```
ansible-playbook -i hosts.yaml 2_ConfiguracionNFS.yml
```

# 4 Datos de interés
- La estructura de los distintos roles se ha generado con "ansible-galaxy" de la siguiente forma:
```
## Dentro de la carpeta roles:
ansible-galaxy init {{ NOMBRE_ROL }}
```
