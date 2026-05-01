# final-project

Домашнє завдання з повним CI/CD-процесом для Django-застосунку на базі Terraform, EKS, ECR, Helm, Jenkins і Argo CD.

## Що реалізовано

- Terraform-модулі для `S3 + DynamoDB`, `VPC`, `ECR`, `EKS`
- Додавання `AWS EBS CSI Driver` для PVC у EKS
- Встановлення `Jenkins` через `Helm` із Terraform
- Встановлення `Argo CD` через `Helm` із Terraform
- Встановлення моніторингу: `Prometheus` і `Grafana` через Helm/Terraform
- Власний Helm chart для Django-застосунку
- Jenkins pipeline через Kubernetes agent (`Kaniko + Git`)
- GitOps-ланцюг `Jenkins -> ECR -> Helm values -> Argo CD sync`

## Архітектура

1. Terraform створює `VPC`, `EKS`, `ECR`, `OIDC/IRSA`, `Jenkins`, `Argo CD`, `Prometheus` і `Grafana`.
2. Jenkins запускає pipeline в Kubernetes pod.
3. Kaniko збирає Docker-образ із [django/Dockerfile](django/Dockerfile) і пушить його в ECR.
4. Jenkins оновлює тег образу в [charts/django-app/values.yaml](charts/django-app/values.yaml) і пушить зміни в Git.
5. Argo CD відстежує Git-репозиторій і автоматично синхронізує застосунок у кластері.
6. Prometheus збирає метрики з Kubernetes, Grafana візуалізує їх через дашборди.

## Структура проєкту

```text
final-project/
├── backend.tf
├── main.tf
├── outputs.tf
├── Jenkinsfile
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── hpa.yaml
│           ├── ingress.yaml
│           └── service.yaml
├── django/
│   ├── Dockerfile
│   ├── manage.py
│   ├── requirements.txt
│   └── goit/
└── modules/
    ├── argo_cd/
    ├── ecr/
    ├── eks/
    ├── jenkins/
    ├── monitoring/
    ├── s3-backend/
    └── vpc/
```

## Перед запуском

Потрібно мати встановлені:

- `Terraform`
- `AWS CLI`
- `kubectl`
- `Helm`
- доступ до AWS-акаунта з правами на `EKS`, `ECR`, `IAM`, `EC2`, `S3`, `DynamoDB`

Налаштування AWS CLI:

```powershell
aws configure
```

## Важливі місця для заповнення

Перед `terraform apply` замініть плейсхолдери:

- `repo_url` у [modules/argo_cd/variables.tf](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd/variables.tf) на ваш GitHub-репозиторій із гілкою `final-project`
- `repo_target_revision` у [modules/argo_cd/variables.tf](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd/variables.tf) на потрібну гілку
- `image.repository` у [charts/django-app/values.yaml](d:/Study/Neoversity/DevOps/final-project/charts/django-app/values.yaml) на фактичний `ecr_repository_url` із Terraform outputs
- `ECR_REGISTRY` і `GITOPS_REPOSITORY` у [Jenkinsfile](d:/Study/Neoversity/DevOps/final-project/Jenkinsfile) на ваші значення

## Як застосувати Terraform

```powershell
terraform init
terraform validate
terraform apply
```

Після `apply` будуть створені:

- `EKS` кластер і node group
- `OIDC provider` для `IRSA`
- `AWS EBS CSI Driver`
- `ECR` repository
- `Jenkins` у namespace `jenkins`
- `Argo CD` у namespace `argocd`
- `Prometheus` і `Grafana` у namespace `monitoring`

## Моніторинг: Prometheus і Grafana

Моніторинг розгортається автоматично через Terraform/Helm у namespace `monitoring`.

### Доступ до Grafana

1. Отримайте пароль адміністратора (якщо не змінювали, за замовчуванням admin123 або з секрету):

```powershell
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | % { [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_)) }
```

2. Отримайте адресу сервісу Grafana:

```powershell
kubectl get svc -n monitoring
```

3. Відкрийте Grafana у браузері (наприклад, через port-forward):

```powershell
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Відкрийте http://localhost:3000

### Додавання Prometheus як data source у Grafana

- Через UI: Connections → Data sources → Add data source → Prometheus
- URL для підключення: `http://prometheus-server.monitoring.svc.cluster.local`
- Натисніть Save & Test

- (Опціонально) Для автоматизації додайте data source у `grafana-values.yaml`:

```yaml
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus-server.monitoring.svc.cluster.local
        isDefault: true
```

## Jenkins

Pipeline описаний у [Jenkinsfile](d:/Study/Neoversity/DevOps/final-project/Jenkinsfile).

Що робить pipeline:

1. Забирає код репозиторію.
2. Збирає Docker-образ через `Kaniko`.
3. Пушить образ у `Amazon ECR`.
4. Оновлює `charts/django-app/values.yaml` новим тегом образу.
5. Комітить і пушить зміну в Git.

Для роботи Jenkins job потрібно створити credentials:

- `github-token` типу `Username with password`
  - username: ваш GitHub username
  - password: ваш GitHub PAT

Як перевірити Jenkins job:

1. Отримайте зовнішній endpoint Jenkins через `kubectl get svc -n jenkins`.
2. Увійдіть із логіном `admin` і паролем із Terraform output `jenkins_admin_password`.
3. Створіть pipeline job, що використовує [Jenkinsfile](d:/Study/Neoversity/DevOps/final-project/Jenkinsfile).
4. Запустіть build і перевірте, що з’явився новий тег у `ECR` і коміт у Git.

## Argo CD

Argo CD встановлюється з модуля [modules/argo_cd](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd).

Argo CD Application створюється локальним chart-ом у:

- [modules/argo_cd/charts/Chart.yaml](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd/charts/Chart.yaml)
- [modules/argo_cd/charts/templates/application.yaml](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd/charts/templates/application.yaml)
- [modules/argo_cd/charts/templates/repository.yaml](d:/Study/Neoversity/DevOps/final-project/modules/argo_cd/charts/templates/repository.yaml)

Як побачити результат в Argo CD:

1. Отримайте пароль:

```powershell
kubectl -n argocd get secret argo-cd-initial-admin-secret -o jsonpath="{.data.password}" | % { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

2. Отримайте endpoint:

```powershell
kubectl get svc -n argocd
```

3. Увійдіть під користувачем `admin`.
4. Відкрийте application `django-app` і перевірте статус `Synced` та `Healthy`.

## Helm chart Django

Власний Helm chart розташований у [charts/django-app](d:/Study/Neoversity/DevOps/final-project/charts/django-app).

У ньому є:

- `Deployment`
- `Service`
- `ConfigMap`
- `HPA`
- опціональний `Ingress`

Локальна перевірка chart:

```powershell
helm lint .\charts\django-app
helm template django-app .\charts\django-app
```

## Корисні команди

```powershell
aws eks update-kubeconfig --region eu-north-1 --name final-project-eks
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get applications -n argocd
kubectl logs -n jenkins deploy/jenkins
```

## Схема CI/CD

```text
Git push -> Jenkins pipeline -> Kaniko build -> ECR push -> update Helm values in Git -> Argo CD sync -> rollout in EKS -> Моніторинг у Grafana
```

## Очистка ресурсів

```powershell
terraform destroy
```
