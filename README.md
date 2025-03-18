# DevOps
Для реализаций необходимо что бы уже были 2 сервера, один на Debian, второй на CentOS (AlmaLinux)
и на них был установлен python3, а также на обоих серверах пользователю root подложен один и тот же открытый ssh ключ.
запускаем скрипт он установит зависимости на хосты и добавить правило в firewalld для centos 
```bash
./requirements.sh ansible/inventory/hosts
```
Если при установки ansible возникли проблемы на  AlmaLinux 9,  Ansible не находится в стандартных репозиториях, потому что его переместили в EPEL. Чтобы установить Ansible, нужно выполнить следующие шаги:
```bash
dnf install -y epel-release
dnf config-manager --set-enabled crb
```

## Ansible Playbook: Установка PostgreSQL на сервер с наименьшей загрузкой CPU
```
DEVOPS/
├── ansible/
│   └── inventory
│        └── hosts
│   └── roles
        └── configure_postgresql
             └── handlers
                  └── main.yml
             └── tasks
                  └── main.yml
        └── configure_postgresql_user
             └── tasks
                  └── main.yml
        └── determine_least_loaded_server
             └── tasks
                  └── main.yml
        └── gather_cpu_load
             └── tasks
                  └── main.yml
        └── install_postgresql
             └── tasks
                  └── main.yml
│   └── playbook.yml
│   └── vars.yml
├── README.md
└── requirements.sh
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
