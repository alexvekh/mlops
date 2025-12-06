# Інфраструктура: Terraform + ArgoCD

Цей проєкт автоматизує створення Kubernetes-інфраструктури за допомогою Terraform, а також налаштовує ArgoCD для керування застосунками.

## 📦 Project Structure


├── s3
│    └── main.tf
├── eks-vpc-cluster/
│    ├── main.tf
│    ├── variables.tf
│    ├── outputs.tf
│    ├── terraform.tf
│    ├── backend.tf
│    ├── vpc/
│    │    ├── main.tf
│    │    ├── variables.tf
│    │    ├── outputs.tf
│    │    ├── terraform.tf
│    │    └── backend.tf
│    ├── eks/
│    │    ├── main.tf
│    │    ├── variables.tf
│    │    ├── outputs.tf
│    │    ├── terraform.tf
│    │    └── backend.tf
└── argocd
│    ├── main.tf
│    ├── variables.tf
│    ├── outputs.tf
│    ├── terraform.tf
│    └── backend.tf
└── README.md



## 📦 1. Як запустити Terraform


Перейдіть у директорію з Terraform-конфігурацією:

cd terraform

Ініціалізація Terraform
terraform init

Перегляд плану змін
terraform plan

Застосування інфраструктури
terraform apply


Підтвердіть виконання, ввівши:

yes


Після завершення Terraform створить:

Kubernetes-кластер (якщо використовується cloud provider),

ArgoCD namespace,

базові ресурси.

🎯 2. Як перевірити, що ArgoCD працює

Перевіряємо стан ресурсів у namespace infra-tools:

kubectl -n infra-tools get pods


Очікуваний результат:

pod'и типу argocd-server, argocd-repo-server, argocd-application-controller повинні бути Running.

Якщо хтось у статусі CrashLoopBackOff — це треба діагностувати.

Також перевіряємо сервіс:

kubectl -n infra-tools get svc argocd-server

🌐 3. Як відкрити UI ArgoCD
Варіант 1 — через Port Forward
kubectl port-forward svc/argocd-server -n infra-tools 8080:80


Відкрити браузер:

http://localhost:8080

Логін у ArgoCD
Отримати початковий пароль:
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


Логін:

Username: admin
Password: <пароль вище>

📡 4. Як перевірити, що деплой відбувся
Перевірити списки застосунків ArgoCD
kubectl -n infra-tools get applications
kubectl -n infra-tools get applicationsets


Якщо застосунок створено — має бути у списку.

Переглянути стан застосунку
kubectl -n infra-tools get application <app-name> -o wide


В UI:

Healthy — застосунок працює коректно

Synced — ArgoCD застосував YAML-файли

OutOfSync — конфігурація змінилась у Git

Перевірити Kubernetes-ресурси, які створив застосунок
kubectl -n <namespace> get all

📁 5. Посилання на Git-репозиторій із application.yaml

Репозиторій із конфігурацією ArgoCD:

👉 https://github.com/
<your-repo>/path/to/application.yaml

---
---

---
===



Проєкт автоматизує створення VPC та EKS кластера через Terraform з використанням офіційних модулів.

---




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
  - node_group2 = t3.small, min = 2, max = 3, desired = 2

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

![node-groups.jpg](node-groups.jpg)

## 🧹 How to Destroy Infrastructure

        terraform destroy
⚠️ Warning:
This will remove everything including VPC, EKS cluster, and node groups.