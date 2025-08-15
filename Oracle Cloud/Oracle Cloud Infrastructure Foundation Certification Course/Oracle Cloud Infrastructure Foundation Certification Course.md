### Visão geral dos Serviços
![[Overview-oci-componentes.png]]

### Arquitetura OCI

#### 1. Regions 
As regiões são locais geograficos onde os datacenter da Oracle estão, na mesma região pode container 1 ou mais Availability Domains(Disponibilidade de Dominio).

#### 2. Availability Domains (AD)
Disponibilidade de Dominio são uma estrutura de tolerancia a falha em um região que é conectada a um rede de baixa latencia mas de alta velocidade, não compartilham fisicamente o mesmo espaço ou hardware pois não ficam em um mesmo Data Center. Desta forma mesmo que por algum motivo um Availability Domains fique indisponivel em determinada região, dificilmente outro Availability Domains fica indisponivel também. 
![[Availability Domains.png]]
#### 3. Fault Domains (FD)
É o conjunto de Hardware e da infra necessária para prover um ou mais Availability Domains. São "Data Centers logico com 1 dominio" sendo que no exemplo abaixo são 3 divididos logicamente dentro do um mesmo Avaiability Domains.
![[Fault Domains.png]]
#### Escolhendo um Região

Um região pode ser escolhida baseada na origem de acesso ou seja mais perto do usuário final, dessa forma o usuário tem um melhor experiencia pois toma vantagem de ter um acesso com menor latencia e com grande peformance. Pode ser baseada em Data Residency & Compliance on por leis do pais ou requerimentos de tratativa interna os dados devem permanecer naquela determinada região. Por ultimo baseado na disponibilidade de serviço, novo serviços baseado em cloud ficam disponiveis baseados na demanda de determinada região, compliance, disponibilidade de recurso e outros fatores.

### Identidade e Gerenciament de acesso
#### Introdução
Identity and Access Management Service

![[Identity Domains.png]]Primeiro criamos um Dominio de Identidade, dentro dele usuário e grupos, depois você aplica politicas de permissão de acesso sendo possivel atribuir essa politica em Compartimentos ou Recursos.

Cada recurso dentro da Oracle Cloud tem um `ID` (Oracle Cloud ID - OCID) que segue essa nomemclatura `ocid1.<RESOURCE TYPE>.<REALM>.[REGION].[.FUTURE USE].<UNIQUE ID>`. 
Exemplo de um Block Volume
```shell
ocid1.volume.oc1.geo-region-1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Compartment
Um compartimento pode ser utilizado tanto para isolamento de recursos quanto para controle de acesso como por examplo o um compartimento chamado *Network* nesse compartimento haverá apenas recursos relacionado a rede e posso entregar acesso a um grupo de administradores focados no gerenciamento desses recursos.

Importante: o compartimento root pode ter todos os recursos dentro dele logo é um boa praticar criar seus proprio compartimentos e os recursos necessários dentro deles. 

Compartimentos são criados globalmente logo para cada região que você tem acesso você verá o mesmo compartimento.

Em cada compartimento é possivel criar cotas, por exemplo em determinado compartimneto não é permitido criar Block Storage ou determinada recursos assim como também é possivel criar limites de orçamento por compartimento, assim quando um comparimento atingir determinado orgamento você será notificado.

Outros exemplos de compartimentos:
- Production
- Development
- Business Unit
- Region Based

![[Criando Compartimentos.png]]
#### AuthN and AuthZ

Principals 
São entidades IAM que tem permissões para interagir com recursos OCI assim como os proprios recursos como computer block storage por interagirem com outros recursos (OCI Resources)

AuthN
- Login com usuário e senha 
- API Signing Keys: que são bastante utilizado quando é feito requisições via API ou CLI.
- Auth Tokens: para autenticar com APIs de terceiros

AuthZ
Lida com permissões e dentro da OCI essas permissões são IAM polices. Tudo tem o parametro Deny por padrão.

```shell
Allow <domain_name>/<group_name> to <verb> <resource-type> in <location>
```
Ex:f
```shell
Allow group sandbox-domain/oci-admin-group to manage buckets in compartment sandbox
```

- group_name: grupo_de_acesso: Ex: Computer-Admins
- Verbs: inspect. read, use, manage.
- resource-type
	- Aggregate resource type: all-resources, database-family, instance-family, virtual-network-family, volume,family
	- Individual resource type: db-systems, db-nodes, instance intances-images, buckets, Volumes.

![[AuthN and AuthZ.png]]

#### Tenancy
![[Tenancy Setup.png]]
Exemplo de permissões basicas para o OCI-admin-group:

```shell
Allow group OCI-admin-group to manage all-resources in tenancy

Allow group OCI-admin-group to manage domains in tenancy
Allow group OCI-admin-group to manage users in tenancy
Allow group OCI-admin-group to manage groups in tenancy
Allow group OCI-admin-group to manage dynamic-groups in tenancy
Allow group OCI-admin-group to manage policies in tenancy
Allow group OCI-admin-group to manage compartments in tenancy

```

### Networking

#### VCN 
VCN (Virtual Cloud Network): é uma rede definida por software (SDN) na Nuvem. Visa criar um rede privada onde outras maquinas e outros serviços possam se comunicar de forma segura e isolada. 

```
VCN, 10.0.0.0/16
├── Public Subnet, 10.0.1.0/24
├── Private Subnet, 10.0.2.0/24
├── ... Subnet, 10.0.x.x/24
```

![[VCN.png]]

Diferentes Mecanismos  dentro de uma VCN:

- `Internet Gateway`: Exemplo de um servidor Web que precisa acessar a internet e ser acessado publicamente. Nesse cenário o trafego pode ir a internet e voltar para o mesmo servidor.

- `Nat Gateway`: (NAT as a Service), usado quando um determinado servidor precisa  acessar a internet mas o mesmo não será acessivel pela internet, ou seja, permite Outbound e bloqueia Inbound.

- `Service Gateway`: Permite acessar outros recursos Publicos da Oracle Cloud como Object Storage mas sem acessar a internet publica ou seja sem Internet ou Nat Gateway.

Um outro mecanismo dentro de um VCN mas utilizado para comunicação em site por examplo entre cloud e a rede On-Premises chamado de `Dynamic Routing Gateway`

- Site-to-Site Connect
- FastConnect

#### Route Tables

Um VCN utiliza as `Route Table` (tabelas de roteamento) para enviar trafego para fora de vcn em direção a Internet, On-Premises Network ou para outra VCN. Cada regra consiste em CIDR Block (0.0.0.0/0) e Route Target (Next Hop) conforme exemplo:
![[route-table.png]]

No exemplo, suponha que há um banco de dados rodando em Private Subnet nesse caso temos o Nat Gateway que permitirá o servidor realizar updates via internet, e nossa Route Table que permitirar esse e outras conexão.

A Primeira regra permite o trafego em direção ao Nat Gateway, a segunda para o Dynamic Routing Gateway na rede 192.168.0.0/16 onde poderia estar rodando um servidor DNS On-Premises da qual esse banco de dados precisa resolver nome nesse caso hipotético. 

A regra que for mais especifica ou que contenha o maior prefixo tem maior prioridade, no exemplo a regra permitindo o acesso a 192.168.0.0/16 tem prioridade sobre o acesso ao Nat Gateway.

Importante: O trafego entre a Subnet Publica e Privada dentro de uma vcn é gerenciado pelo VCN Local Route logo não é necessário configuração explicita entre elas para se comunicarem. 

Em cenário onde você tem varias VCNs possivelmente em regioes diferentes, como elas se comunicam ?

As VCNs estão na mesma Região se comunicao atravez do mecanismo `Local Peering` onde temos o `Local Peering Gateway` que possibilita gerencia essa comunicação. No caso de VCNs em regioes diferentes são os `Remote Perring` onde é utilizado o Dynamic Route Gateway

#### VCN Security
1. Security Lists: equivalente a Security Group (AWS), container uma list de regras de firewall a nivel de instancia permitindo Ingress ou Egress. 
- stateful: Significar que um regra de acesso ingress para uma determinada porta também permite Egress dessa mesmo porta nesta mesma regra.

 1. Network Security Group (NSG): Agrupamentos com multiplas regras. Equivalente a Alias na maioria dos firewalls.

#### Load Balancer

Layer 3/4 (TCP/UPD)
Layer 7 (HTTP/HTTPS)

Demo:
![[Demo Load Balancer.png]]
1. Menu Hamburger > Networking > Criar uma VCN
2. Na config da VCN > Security Lists > Default Seciruty List for vcn....
3. Add Ingress Rule > Source CIDR = 0.0.0.0/0 > Destination Port Range = 80
4. Criar instancias para ficarem atras do loadbalancer
	4.1 Em Networking e subnet escolha a subnet privada
	4.2 Em Public IPv4 address marque `Do not assign a public IPv4 address`
5. Provisionando LoadBalancer:
	5.1 Menu Hamburger > Networking > Load Balancer.
	5.2 Choose vivibility type: Public
	5.3 Virtual Cloud Network: <nome-sua-vcn>
	5.4 Subnet: <public-subnet-***>
	5.5 Next
	5.6 Weighted round robin
	5.7 Add backends
	5.8 Selecione os servidores que ficaram atras deste Load Balancer
	5.9 Next
	6.0 Esclha http na opção do Listener
	7.1 (Opicional) Desabilite Error logs. 

### Compute

Preemptible VMs: são VMs com curto tempo de vida e com menor custo. (50%)

Uma instancia tem dependencia de um block volume que ficam em um remote storage separas em boot e data para uma mesma vm.

#### Cloud shell
é uma pequena maquina virtual com linux (5 Gigas) que já vem com python java e outros utilitarios.