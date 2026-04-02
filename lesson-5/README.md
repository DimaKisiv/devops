# Lesson 5 Terraform Project

## Опис проєкту

Цей проєкт містить Terraform-конфігурацію для розгортання базової AWS-інфраструктури за допомогою модулів.

Проєкт включає:

- S3 backend для збереження Terraform state
- DynamoDB для блокування state
- VPC з публічними та приватними підмережами
- ECR-репозиторій для контейнерних образів

## Структура проєкту

```text
lesson-5/
|-- backend.tf
|-- main.tf
|-- outputs.tf
|-- README.md
`-- modules/
    |-- s3-backend/
    |   |-- dynamodb.tf
    |   |-- outputs.tf
    |   |-- s3.tf
    |   `-- variables.tf
    |-- vpc/
    |   |-- outputs.tf
    |   |-- routes.tf
    |   |-- variables.tf
    |   `-- vpc.tf
    `-- ecr/
        |-- ecr.tf
        |-- outputs.tf
        `-- variables.tf
```

## Основні команди

### Ініціалізація Terraform

```bash
terraform init
```

### Перегляд плану змін

```bash
terraform plan
```

### Застосування конфігурації

```bash
terraform apply
```

### Видалення інфраструктури

```bash
terraform destroy
```

## Важлива Примітка

Для роботи S3 backend бакет має існувати заздалегідь у вашому AWS акаунті, оскільки Terraform backend ініціалізується до створення ресурсів через `terraform apply`

1. Тому потрібно спочатку видалити вміст файлу backend.tf
2. Потім виконати команду terraform apply, щоб створився бакет
3. Тоді повернути вмістт файлу backend.tf та виконати потворно terraform init щоб перемістити state в s3 bucket

## Опис модулів

### s3-backend

Модуль `s3-backend` відповідає за:

- створення S3-бакета для Terraform state
- увімкнення versioning для state-файлів
- створення DynamoDB-таблиці для блокування state
- виведення імені бакета, URL бакета та імені таблиці DynamoDB

### vpc

Модуль `vpc` відповідає за:

- створення VPC з CIDR-блоком
- створення 3 публічних підмереж
- створення 3 приватних підмереж
- створення Internet Gateway
- створення NAT Gateway
- налаштування route tables для public і private subnet
- виведення ID основних мережевих ресурсів

### ecr

Модуль `ecr` відповідає за:

- створення ECR-репозиторію
- увімкнення автоматичного сканування образів
- налаштування policy доступу до репозиторію
- виведення URL та імені репозиторію

## Кореневі файли

- `main.tf` підключає модулі `s3-backend`, `vpc` та `ecr`
- `backend.tf` містить налаштування S3 backend для Terraform state
- `outputs.tf` виводить загальні outputs з модулів
