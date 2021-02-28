variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

# Dado que nuestra cuenta limita a 4 núcleos y solo 1 no es suficiente para el master
# se genera 1 máquina del tipo "Standard_D2_v2" y 2 del tipo "Standard_D1_v2"

variable "vm_size_master_nfs" {
  type = string
  description = "Tamaño de la máquina virtual master/nfs"
  default = "Standard_D2_v2" # 7 GB, 2 CPU 
}

variable "vm_size_workers" {
  type = string
  description = "Tamaño de las máquinas virtuales de los workers"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
}

variable "vms_master_nfs" {
  type = list(string)
  description = "Listado de máquinas virtuales que se van a crear como master/nfs"
  default = ["master"]
}

variable "vms_workers" {
  type = list(string)
  description = "Listado de máquinas virtuales como workers"
  default = ["worker1", "worker2"]
}