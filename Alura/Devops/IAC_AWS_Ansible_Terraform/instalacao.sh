###########################
## INSTALANDO TERRAFORM ###
###########################

# Instando Terraform no Ubuntu
echo "Instando Terraform ---------------------------------------------->"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform

# Instalando python3
echo "Instando python3 ---------------------------------------------->"
sudo apt install python3

# Instalando Ansible
echo "Instando Ansible ---------------------------------------------->"
sudo apt update
sudo apt install software-properties-common
#sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible

# Instalando AWS CLI
echo "Instando AWS CLI ---------------------------------------------->"
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
which aws
echo ""
echo " ---------------Instaldos-------------"
echo "[+] $(terraform -v | head -n1)"
echo "[+] $(python3 --version)"
echo "[+] $(ansible --version | head -n1)"
echo "[+] $(aws --version)"
echo " -------------------------------------"

# Apos ter criado o arquivo main.tf com uma config basica para subir uma maquina
# Iniciando o Terraform. Vai baixar algumas dependencia e criar o arquivo .terraform.lock.hcl!
# Se tiver dado tudo certo irá aparecer a mensagem Terraform has been successfully initialized!
terraform init

# Ver o plano do terraform (Não cria a maquina. Apernas te mostra no terminal o que será feito)
terraform plan

# Aplicando a configuração/Criando a instancia
#terraform apply