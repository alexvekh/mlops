# EKS Cluster with VPC and Multiple Node Groups (Terraform)

Проєкт автоматизує створення VPC та EKS кластера через Terraform з використанням офіційних модулів.

---

## 📦 Project Structure

- eks-vpc-cluster/
- ├── main.tf              # імпортує обидва модулі: vpc і eks
- ├── variables.tf         # глобальні змінні для всього проєкту
- ├── outputs.tf           # глобальні output-и
- ├── terraform.tf         # локальні конфігурації Terraform (опційно)
- ├── backend.tf           # S3 backend для зберігання стану
- ├── vpc/
- │  - ├── main.tf          # виклик модуля VPC
- │  - ├── variables.tf
- │  - ├── outputs.tf
- │  - ├── terraform.tf
- │  - └── backend.tf
- ├── eks/
- │  - ├── main.tf          # виклик модуля EKS
- │  - ├── variables.tf
- │  - ├── outputs.tf
- │  - ├── terraform.tf
- │  - └── backend.tf
- └── README.md



---

## 🚀 Requirements

Before you start, install:

 1. Terraform - https://developer.hashicorp.com/terraform/downloads

 2. AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

 3. Configure AWS credentials:
 
        aws configure




## ⚙️ How to Deploy
1. Створити бакет
        
       aws s3 mb s3://mlops-tfstate-hw --region us-east-1

2. Ініціалізувати Terraform:

       terraform init

3. Validate configuration

       terraform validate

4. See what Terraform will create

       terraform plan


5. Deploy infrastructure

       terraform apply



### 🎉 Що буде створено

- Custom VPC
- 2 public subnets
- 2 private subnets
- Route tables
- Internet gateway
- NAT gateway
- EKS cluster
- Kubernetes version (configured in eks/main.tf)
- Public endpoint enabled
- Core addons installed:
- coredns
- kube-proxy
- vpc-cni
- eks-pod-identity-agent
- Two node groups:
  - node_group1 = t3.micro, min = 1, max = 2, desired = 1
  - node_group2 = t3.ЫЬФДД, min = 2, max = 3, desired = 2

### 🔗 Outputs

After apply, you will see:

- vpc_id
- public_subnets
- private_subnets
- cluster_name

Example:

        cluster_name = "my-cluster"
        private_subnets = [
        "subnet-08d95f6c002322cc7",
        "subnet-078dc8b59ce6f2e88",
        ]
        public_subnets = [
        "subnet-054b39311e5af2180",
        "subnet-076f08c69f87822e6",
        ]
        vpc_id = "vpc-0889af777d5b22c3f" 

⎈ Connecting kubectl to Your EKS Cluster

## ✅ Після apply:

- Перевірте, що кластер створено:

      aws eks --region <region> update-kubeconfig --name <your-cluster-name>
        
      # aws eks update-kubeconfig --region us-east-1 --name my-cluster

      kubectl get nodes


- Також можна подивитись інфо

      kubectl cluster-info
      kubectl get namespaces
      kubectl get nodes
      kubectl describe node <node_name>
      kubectl get pods -A
      kubectl get nodes --show-labels
      aws eks list-clusters --region us-east-1
      aws eks describe-cluster --name my-cluster --region us-east-1


## 🧹 How to Destroy Infrastructure

    terraform destroy
⚠️ Warning:
This will remove everything including VPC, EKS cluster, and node groups.