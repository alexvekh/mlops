# Інфраструктура: Terraform + ArgoCD

Цей проєкт автоматизує створення Kubernetes-інфраструктури за допомогою Terraform, а також налаштовує ArgoCD для керування застосунками. 

ArgoCD налаштовано на автоматичний деплой застосунків із Git-репозиторію — реалізовано повноцінний GitOps-підхід: кластер завжди синхронізовано з конфігурацією в Git.

## 📦 Project Structure


        /
        ├── s3/
        │   └── main.tf
        ├── eks-vpc-cluster/
        │   ├── main.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   ├── terraform.tf
        │   ├── backend.tf
        │   ├── vpc/
        │   │   ├── main.tf
        │   │   ├── variables.tf
        │   │   ├── outputs.tf
        │   │   ├── terraform.tf
        │   │   └── backend.tf
        │   └── eks/
        │       ├── main.tf
        │       ├── variables.tf
        │       ├── outputs.tf
        │       ├── terraform.tf
        │       └── backend.tf
        ├── argocd/
        │   ├── main.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   ├── terraform.tf
        │   └── backend.tf
        └── README.md



## 🚀 Requirements

Before you start, install:
 1. Terraform - https://developer.hashicorp.com/terraform/downloads
 2. AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
 3. Configure AWS credentials:
        aws configure


## 📦 Як запустити Terraform?

### 1. Сворити бакет

        cd s3
        terraform init
        terraform plan
        terraform aply

- Буде створено amazon s3 backet для зберігання terraform.tfstate - стану всієї інфраструктури.       

### 2. Запустити clucter
        cd ../eks-vbc-cluster
        terraform init
        terraform plan
        terraform aply

- Після завершення Terraform створить, VPC, приватні та публічні сабнети, Internet Gateway / NAT, EKS кластер, тобто готовий Kubernetes-кластер.

### 3. Встановити ArgoCD
        cd ../argocd
        terraform init
        terraform plan
        terraform aply

- В результаті Terraform створить namespace infra-tools, встановить ArgoCD через Helm chart.

### 4. Створити ApplicationSet

- Розкоментувати код в argocd/main.tf (рядки 25 і далі)
        
        resource "kubernetes_manifest" "namespaces_appset" {
           ...
        }

- та втановити знову 

        terraform init
        terraform plan
        terraform aply

- Тепер, коли CRD уже встановлені, Terraform успішно створить ApplicationSet

## 🎯 Як перевірити, що ArgoCD працює?

Перевірити pod-и:

        kubectl -n infra-tools get pods

 Очікувано:

        argocd-server
        argocd-repo-server
        argocd-application-controller

усі у статусі Running.


Перевірити сервіс:

        kubectl -n infra-tools get svc argocd-server


## 🌐 Як відкрити UI ArgoCD?

Отримати початковий пароль:

        kubectl -n infra-tools get secret argocd-initial-admin-secret \
        -o jsonpath="{.data.password}" | base64 -d



Запустити Port-forward:

        kubectl port-forward svc/argocd-server -n infra-tools 8080:80

Відкрити браузер:

        http://localhost:8080


🔑 Логін:

Username: admin
Password: <отриманий вище пароль>

О

## 🎯 Як перевірити, що деплой ApplicationSet працює?

Переглянути всі застосунки ArgoCD:

        kubectl -n infra-tools get applications
        kubectl -n infra-tools get applicationsets

Перевірити стан конкретного застосунку:

        kubectl -n infra-tools get application <app-name> -o wide


Стани:
- Synced — все застосовано
- Healthy — усі ресурси у нормі
- OutOfSync — зміни в Git, але не в кластері

Перевірити створені Kubernetes-ресурси:
kubectl -n <namespace> get all


## 🧹 Як видалити Infrastructure
        
        terraform destroy

## 📁 8. Посилання на Git-репозиторій

Проєкт налаштовано на деплой із Git-репозиторію.



👉 https://github.com/alexvekh/goit-argo.git




