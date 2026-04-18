# lesson-8-9

Повний CI/CD-процес для Django-застосунку з використанням Terraform, Jenkins, Kaniko, Amazon ECR, Helm та Argo CD.

## Що реалізовано

- Terraform-модулі для `S3 + DynamoDB`, `VPC`, `ECR`, `EKS`, `Jenkins`, `Argo CD`
- Jenkins, встановлений через Helm у Kubernetes
- Jenkins pipeline через `Jenkinsfile`, який:
  - забирає код застосунку з Git
  - збирає Docker image з [lesson-8-9/django/Dockerfile](d:\Study\Neoversity\DevOps\lesson-8-9\django\Dockerfile)
  - пушить image в Amazon ECR через Kaniko
  - оновлює `lesson-8-9/charts/django-app/values.yaml` у GitOps-репозиторії
- Argo CD, встановлений через Helm у Kubernetes
- Argo CD Application, яка стежить за Helm chart і автоматично синхронізує зміни

## CI/CD схема

```text
Git push -> Jenkins -> Kaniko build -> Amazon ECR -> update values.yaml in GitOps repo -> Argo CD sync -> EKS deploy
```

## Важливий момент про Docker image

У цьому рішенні локально збирати image через Docker Desktop не потрібно.

- Джерело застосунку: `lesson-8-9/django`
- Jenkins сам виконує build у Kubernetes agent
- Kaniko пушить image напряму в ECR
- Argo CD підтягує новий tag через зміни в GitOps-репозиторії

Локальний Docker може знадобитися лише для ручної перевірки, але не для основного CI/CD процесу.

## Структура

```text
lesson-8-9/
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── terraform.tfvars.example
├── Jenkinsfile
├── django/
│   ├── Dockerfile
│   ├── manage.py
│   ├── requirements.txt
│   └── goit/
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
    ├── s3-backend/
    ├── vpc/
    ├── ecr/
    ├── eks/
    ├── jenkins/
    └── argo_cd/
```

## Передумови

Потрібно мати встановлені:

- `Terraform`
- `AWS CLI`
- `kubectl`
- `Helm`

Також потрібні:

- GitHub repository з кодом застосунку та `lesson-8-9/Jenkinsfile`
- окремий GitOps repository або той самий repository, якщо ти хочеш спростити демо
- GitHub token з правами на clone/push
- AWS access key для push в ECR

## Як застосувати Terraform

1. Скопіюй `terraform.tfvars.example` у `terraform.tfvars` і заповни свої значення.

2. Ініціалізуй Terraform:

```powershell
cd .\lesson-8-9
terraform init
terraform validate
```

3. Створи інфраструктуру:

```powershell
terraform apply
```

4. Налаштуй kubeconfig:

```powershell
aws eks update-kubeconfig --region eu-north-1 --name lesson-8-9-eks
kubectl get nodes
```

5. За потреби переведи state у S3 backend:

- розкоментуй backend у [lesson-8-9/backend.tf](d:\Study\Neoversity\DevOps\lesson-8-9\backend.tf)
- виконай `terraform init -reconfigure`

## Як перевірити Jenkins

Отримати сервіси:

```powershell
kubectl get svc -n jenkins
```

Отримати пароль адміністратора:

```powershell
terraform output -raw jenkins_admin_password
```

У Jenkins буде створений job `django-ci`.

Щоб перевірити job:

1. Відкрий Jenkins UI.
2. Запусти `django-ci` вручну або зроби новий push у репозиторій.
3. Переконайся, що build проходить етапи:
   - checkout
   - kaniko build
   - push to ECR
   - update GitOps values

## Як побачити результат в Argo CD

Отримати сервіси:

```powershell
kubectl get svc -n argocd
```

Отримати initial admin password:

```powershell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | %{ [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

Перевірити application:

```powershell
kubectl get applications -n argocd
kubectl describe application django-app -n argocd
```

Після оновлення `values.yaml` Jenkins-ом Argo CD має автоматично виконати sync і оновити deployment у namespace `django`.

Якщо використовується один GitHub repository, Jenkins і Argo CD працюють з шляхами від кореня repo:

- `lesson-8-9/django`
- `lesson-8-9/charts/django-app`

## Що саме оновлює Jenkins

Jenkins змінює такі поля у GitOps-репозиторії:

```yaml
image:
  repository: <aws-account>.dkr.ecr.<region>.amazonaws.com/lesson-8-9-ecr
  tag: <build-number>-<short-commit>
```

Саме цю зміну бачить Argo CD і запускає deploy нової версії.

## Корисні команди

```powershell
kubectl get pods -A
kubectl get svc -A
kubectl get applications -n argocd
kubectl logs -n jenkins deploy/jenkins
aws ecr describe-images --repository-name lesson-8-9-ecr --region eu-north-1
```

## Очистка ресурсів

```powershell
terraform destroy
```
