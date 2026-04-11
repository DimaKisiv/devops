# lesson-7

Практична робота з Terraform, AWS ECR, AWS EKS, Docker та Helm.

## Що реалізовано

- Terraform-модулі для `S3 + DynamoDB`, `VPC`, `ECR`, `EKS`
- Docker image Django, завантажений в `ECR`
- Helm chart для деплою Django в `EKS`
- `ConfigMap` для environment variables
- `Service` типу `LoadBalancer`
- `HPA` для автоскейлінгу pod-ів

## Структура проєкту

```text
lesson-7/
├── .terraform.lock.hcl
├── backend.tf
├── main.tf
├── outputs.tf
├── README.md
├── terraform.tfstate
├── terraform.tfstate.backup
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── hpa.yaml
│           └── service.yaml
└── modules/
    ├── ecr/
    │   ├── ecr.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── eks/
    │   ├── eks.tf
    │   ├── node.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── s3-backend/
    │   ├── dynamodb.tf
    │   ├── outputs.tf
    │   ├── s3.tf
    │   └── variables.tf
    └── vpc/
        ├── outputs.tf
        ├── routes.tf
        ├── variables.tf
        └── vpc.tf
```

## Використані сервіси AWS

- `S3` для зберігання Terraform state
- `DynamoDB` для state locking
- `VPC` з public/private subnets
- `ECR` для зберігання Docker image
- `EKS` для Kubernetes-кластера
- `ELB` через Kubernetes `Service LoadBalancer`

## Підготовка

Потрібно мати встановлені:

- `Terraform`
- `AWS CLI`
- `Docker Desktop`
- `kubectl`
- `Helm`

Налаштування AWS CLI:

```powershell
aws configure
```

## 1. Ініціалізація і створення інфраструктури

```powershell
terraform init
terraform validate
terraform apply
```

Після `apply` створюються:

- `S3 bucket`
- `DynamoDB table`
- `VPC`
- `public/private subnets`
- `Internet Gateway`
- `NAT Gateway`
- `ECR repository`
- `EKS cluster`
- `EKS node group`

## 2. Збірка і push Docker image в ECR

Docker image збирався в папці `lesson-4`, де був Django-проєкт з `Dockerfile`.

Логін Docker в ECR:

```powershell
cmd /c "aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 437670317020.dkr.ecr.eu-north-1.amazonaws.com"
```

Тегування і push image:

```powershell
docker tag lesson-4-web:latest lesson-7-web:latest
docker tag lesson-7-web:latest 437670317020.dkr.ecr.eu-north-1.amazonaws.com/lesson-7-ecr:latest
docker push 437670317020.dkr.ecr.eu-north-1.amazonaws.com/lesson-7-ecr:latest
```

## 3. Підключення до EKS

```powershell
aws eks update-kubeconfig --region eu-north-1 --name lesson-7-eks
kubectl get nodes
```

## 4. Helm chart

Chart знаходиться в:

```text
charts/django-app/
```

У chart реалізовано:

- `Deployment`
- `Service`
- `ConfigMap`
- `HPA`

## 5. Environment variables через ConfigMap

У `values.yaml` змінні передаються через секцію `config`:

```yaml
config:
  POSTGRES_HOST: "db"
  POSTGRES_PORT: "5432"
  POSTGRES_USER: "django_user"
  POSTGRES_DB: "django_db"
  POSTGRES_PASSWORD: "change_me"
  ALLOWED_HOSTS: "*"
```

У `deployment.yaml` ці змінні підключаються через `envFrom`.

## 6. Деплой застосунку через Helm

Перед деплоєм у `charts/django-app/values.yaml` має бути правильний `image.repository`:

```yaml
image:
  repository: 437670317020.dkr.ecr.eu-north-1.amazonaws.com/lesson-7-ecr
  tag: latest
```

Деплой:

```powershell
helm upgrade --install django-app .\charts\django-app
```

Перевірка:

```powershell
kubectl get pods
kubectl get svc
kubectl get hpa
kubectl get configmap
```

## 7. Доступ до застосунку

Після створення `Service LoadBalancer` застосунок стає доступним через зовнішній AWS ELB URL.

Головна сторінка `/` може повертати `404`, якщо в Django не описаний маршрут для root path. У цьому проєкті застосунок відкривався через:

```text
/admin/
```

## Корисні команди

```powershell
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get svc
kubectl get nodes
```

## Очистка ресурсів

Після завершення роботи ресурси AWS можна видалити:

```powershell
helm uninstall django-app
terraform destroy
```
