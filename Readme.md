# Preparación previa
## Claves ssh
Generamos las claves pública/privada para poder conectar desde el PC a las máquinas generadas. Por simplicidad en la práctica se ha decidido no generar passphrase:
```
ssh-keygen -t rsa
```

# Terraform
## Directorio
Toda la configuración de terraform se encuenta en el directorio con el mismo nombre.

## Estructura
- credentials.tf: No se añade en el repositorio GitHub dado que contiene información sensible (Se añade en .gitignore)
- [main.tf](Terraform/main.tf): 
- [network.tf](Terraform/network.tf)
- [security.tf](Terraform/security.tf)
- [vars.tf](Terraform/vars.tf): Variable para poder utilizar en el resto de ficheros de configuración
- [vm.tf](Terraform/vm.tf): Contiene la configuración de las máquinas virtuales

## Comandos
### - Inicializar configuración
```
terraform init
```

### - Aplicar cambios y desplegar
```
terraform apply
``` 
>_Pedirá confirmación de los cambios que va a aplicar._

### - Eliminar la configuración indicada en los ficheros
```
terraform destroy
```
>_Pedirá confirmación de los cambios que va a aplicar._

# Ansible
## Directorio
Toda la configuración de ansible se encuenta en el directorio con el mismo nombre.

PENDIENTE DE COMPLETAR
