#!/bin/bash
set -e

# Перевіряємо, чи вже встановлений Docker.
# Якщо команди docker немає, оновлюємо список пакетів і встановлюємо Docker.
if ! command -v docker >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y docker.io
fi

# Перевіряємо, чи доступний Docker Compose.
# Якщо ні — вручну завантажуємо compose plugin у папку, де Docker його шукає,
# і даємо файлу право на запуск.
if ! docker compose version >/dev/null 2>&1; then
    sudo mkdir -p /usr/lib/docker/cli-plugins
    sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o /usr/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/lib/docker/cli-plugins/docker-compose
fi

# Перевіряємо, чи є Python 3.
# Якщо немає — встановлюємо.
if ! command -v python3 >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y python3
fi

# Перевіряємо, чи є менеджер пакетів Python pip3.
# Він потрібен, щоб встановлювати Django та інші Python-бібліотеки.
if ! command -v pip3 >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y python3-pip
fi

# Перевіряємо, чи встановлений пакет python3-venv.
# Він потрібен для створення віртуального середовища Python,
# щоб не ставити Django прямо в системний Python.
if ! dpkg -s python3-venv >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y python3-venv
fi

# Вмикаємо Docker як сервіс:
# enable — щоб Docker автоматично запускався після перезавантаження сервера
# start — щоб Docker запустився прямо зараз
sudo systemctl enable docker
sudo systemctl start docker

# Перевіряємо, чи вже є папка venv.
# Якщо її немає — створюємо віртуальне середовище Python.
# Воно потрібне, щоб Django ставився окремо, без конфлікту з системою.
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Активуємо віртуальне середовище.
# Після цього команди python і pip працюватимуть уже всередині venv.
source venv/bin/activate

# Перевіряємо, чи встановлений Django у цьому віртуальному середовищі.
# Якщо ні — оновлюємо pip і встановлюємо Django.
if ! python -m django --version >/dev/null 2>&1; then
    pip install --upgrade pip
    pip install django
fi

# В кінці показуємо версії встановлених інструментів,
# щоб одразу переконатися, що все спрацювало.
docker --version
docker compose version
python3 --version
python -m django --version