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

* Listar cuentas

`az account list`

* Listar el SP

`az ad sp list --display-name {{ NOMBRE_SERVICIO }}`

* Aceptar términos máquina (necesario una vez sepamos que tipos de máquinas vamos a utilizar). El siguiente comando es un ejemplo según la utilizada en la práctica.

`az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810`

## Generamos las claves ssh
Generamos las claves pública/privada para poder conectar desde el PC a las máquinas generadas. Por simplicidad en la práctica se ha decidido no generar passphrase:

`ssh-keygen -t rsa`

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
``` 
>_Si queremos que no nos pida confirmación de los cambios podemos añadir el parámetro "--auto-approve"._

### - Eliminar la configuración indicada en los ficheros
```
terraform destroy
```
>_Si queremos que no nos pida confirmación de los cambios podemos añadir el parámetro "--auto-approve"._

# 3) Ansible
## Directorio
Toda la configuración de ansible se encuenta en el directorio con el mismo nombre.

## Estructura

## Pasos a seguir
### - IPs públicas de las máquinas
Necesitamos obtener las IPs públicas de las máquinas que hemos creado para setearlas en el fichero "hosts.yaml". Para ello tenemos 2 formas:

**Panel de control de Azure**

Accedemos al apartado "[Máquinas virtuales](https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines)" del panel de control de Azure y vamos entrando en cada máquina para revisar la información.

**Utilizando "az cli"**

Con el siguiente comando de "az cli" obtendremos una lista de las máquinas en la que podemos ver información de cada una de ellas (IP pública entre estos datos):

`az vm list-ip-addresses`

En el resultado obtendremos una lista de objetos con la siguiente estructura:
```
 {
    "virtualMachine": {
      "name": "MyVmMasterNfs-master",
      "network": {
        "privateIpAddresses": [
          "10.0.1.10"
        ],
        "publicIpAddresses": [
          {
            "id": "/subscriptions/447c013b-e65b-4b24-9cac-9d1184fde2f2/resourceGroups/kubernetes_rg/providers/Microsoft.Network/publicIPAddresses/pubip-master",
            "ipAddress": "104.45.3.191", // Esta es la IP que nedesitamos
            "ipAllocationMethod": "Dynamic",
            "name": "pubip-master",
            "resourceGroup": "kubernetes_rg"
          }
        ]
      },
      "resourceGroup": "kubernetes_rg"
    }
  }
```

### - Aplicamos la configuración común para todas las máquina

`ansible-playbook -i hosts.yaml 1_ConfiguracionInicial.yml`

### - Configuramos las particiones NFS compartidas entre las máquinas

`ansible-playbook -i hosts.yaml 2_ConfiguracionNFS.yml`

### - Configuramos Kubernetes

`ansible-playbook -i hosts.yaml 3_ConfiguracionKubernetes.yml`

# 4) Datos de interés
- La estructura de los distintos roles se ha generado con "ansible-galaxy" de la siguiente forma:
```
## Dentro de la carpeta roles:
ansible-galaxy init {{ NOMBRE_ROL }}
```
