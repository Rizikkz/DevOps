#!/bin/bash

# Проверка, что указан инвентарный файл
if [ -z "$1" ]; then
  echo "Укажите путь к inventory файлу. Пример: ./requirements.sh ansible/inventory/hosts"
  exit 1
fi

INVENTORY_FILE="$1"

# Проверка наличия Ansible
if ! command -v ansible &> /dev/null; then
  echo "Ansible не установлен. Установите его перед запуском."
  exit 1
fi

# Установка sudo на Debian/Ubuntu, если отсутствует
echo "Установка sudo на Debian/Ubuntu, если отсутствует..."
ansible all -i "$INVENTORY_FILE" -m ansible.builtin.raw -a '
  if [ -f /etc/debian_version ]; then
    apt-get update -y && apt-get install -y sudo
  fi
' || true

# Установка sudo на CentOS/RHEL, если отсутствует
echo "Установка sudo на CentOS/RHEL, если отсутствует..."
ansible all -i "$INVENTORY_FILE" -m ansible.builtin.raw -a '
  if [ -f /etc/redhat-release ]; then
    yum install -y sudo
  fi
' || true

# Запуск установки зависимостей через Ansible
echo "Запуск установки зависимостей на удалённых хостах..."
ansible all -i "$INVENTORY_FILE" -m ansible.builtin.shell -a '
  if [ -f /etc/debian_version ]; then
    echo "Обнаружена Debian/Ubuntu система..."
    sudo apt-get update -y && \
    sudo apt-get install -y python3 python3-pip python3-psycopg2 || { echo "Ошибка при установке пакетов!"; exit 1; }
  elif [ -f /etc/redhat-release ]; then
    echo "Обнаружена CentOS/RHEL система..."
    sudo yum install -y epel-release && \
    sudo yum install -y python3 python3-pip python3-psycopg2 || { echo "Ошибка при установке пакетов!"; exit 1; }

    echo "Открытие порта 5432 в firewalld..."
    sudo firewall-cmd --add-port=5432/tcp --permanent && \
    sudo firewall-cmd --reload || { echo "Ошибка при настройке firewall!"; exit 1; }
  else
    echo "Неизвестная ОС, пропускаем..."
    exit 1
  fi

  echo "Установка завершена!"
' || { echo "Ошибка при выполнении Ansible."; exit 1; }

echo "Зависимости успешно установлены на всех хостах!"
