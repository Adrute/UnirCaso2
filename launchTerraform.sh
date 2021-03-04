echo 'Lanzamos el despliegue con terraform:'

cd Terraform;
terraform init;
terraform apply --auto-approve;
cd ..;

echo 'Listamos las máquinas virtuales:'

az vm list-ip-addresses
