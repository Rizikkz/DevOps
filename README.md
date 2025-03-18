# **DevOps: Автоматическая установка и настройка PostgreSQL**

## **Предварительные требования**  
Для работы playbook'а необходимо:  
1. Два сервера:  
   - Один с **Debian**  
   - Второй с **CentOS (AlmaLinux)**  
2. На обоих серверах должен быть установлен **Python 3**.  
3. У пользователя **root** на обоих серверах должен быть один и тот же **открытый SSH-ключ**. 
4. Установить Python на хосты 

# для Debian
```bash
apt-get update && apt-get install -y python3
```
# для CentOS
```bash
yum install -y python3
```

---

## **Установка зависимостей**  
Запуск скрипта для установки всех необходимых зависимостей на удалённых хостах:  
```bash
./requirements.sh ansible/inventory/hosts
```
⚠ **Важно:**  
Если при установке Ansible на **AlmaLinux 9** возникли проблемы (Ansible отсутствует в стандартных репозиториях), выполните:  
```bash
dnf install -y epel-release
dnf config-manager --set-enabled crb
```

---

## **Описание Ansible Playbook'а**  
Этот playbook автоматически устанавливает и настраивает **PostgreSQL** на сервере с наименьшей загрузкой CPU.  

### **Структура проекта:**  
```
DEVOPS/
├── ansible/
│   ├── inventory/
│   │   └── hosts
│   ├── roles/
│   │   ├── configure_postgresql/
│   │   │   ├── handlers/
│   │   │   │   └── main.yml
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   │   ├── configure_postgresql_user/
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   │   ├── determine_least_loaded_server/
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   │   ├── gather_cpu_load/
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   │   ├── install_postgresql/
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   ├── playbook.yml
│   ├── vars.yml
├── README.md
└── requirements.sh
```

### **Функциональность playbook'а:**  
1. **Сбор информации**:  
   - Получает текущую загрузку CPU на серверах в группах `debian_servers` и `centos_servers`.  
2. **Определение наименее загруженного сервера**:  
   - Выбирает сервер с наименьшей нагрузкой и добавляет его в группу `target_server`.  
3. **Установка и настройка PostgreSQL**:  
   - Устанавливает **PostgreSQL** на выбранном сервере.  
   - Устанавливает **PostgreSQL client** на втором сервере.  
4. **Проверка работоспособности БД**:  
   - Выполняет тестовый SQL-запрос `SELECT 1` на сервере с минимальной загрузкой.  

---

## **Как запустить playbook:**  
```bash
ansible-playbook -i ansible/inventory/hosts ansible/playbook.yml
```