# DevOps
Для реализаций необходимо что бы уже были 2 сервера, один на Debian, второй на CentOS (AlmaLinux)
и на них был установлен ansible, а также на обоих серверах пользователю root подложен один и тот же открытый ssh ключ.
```bash
sudo apt update && sudo apt install -y ansible  # Для Ubuntu/Debian
sudo dnf install -y ansible  # Для CentOS/AlmaLinux
```
Если при установки ansible возникли проблемы на  AlmaLinux 9,  Ansible не находится в стандартных репозиториях, потому что его переместили в EPEL. Чтобы установить Ansible, нужно выполнить следующие шаги:
```bash
dnf install -y epel-release
dnf config-manager --set-enabled crb
dnf install -y ansible
ansible --version
```

## Ansible Playbook: Установка PostgreSQL на сервер с наименьшей загрузкой CPU
```
project/
├── inventory/
│   └── hosts
├── postgres.yml
└── vars.yml
```
### Описание
Этот Playbook выполняет три основных шага:
1. Собирает текущую загрузку CPU со всех серверов в группах `postgres_servers` и `centos_servers`.
2. Определяет сервер с минимальной загрузкой и добавляет его в группу `target_server`.
3. Устанавливает и настраивает PostgreSQL на выбранном сервере.
4. Выполняет проверку БД выполняя запрос sql  'SELECT 1  в установленой PostgreSQL

### Как запустить:
```bash
ansible-playbook -i inventory/hosts postgres.yml 
```
