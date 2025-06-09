# Redpanda

**Мова**: **🇺🇦 Українська** | [🇺🇸 English](README_EN.md)

Проект для демонстрації роботи з Redpanda (Apache Kafka-сумісна платформа потокової обробки даних) у автомобільно-торговельному домені. Включає налаштування кластера Redpanda, коннектори баз даних, KSQL обробку та приклади інтеграції.

## 🏗️ Архітектура

Проект включає:
- **Redpanda Cluster**: 3х вузловий кластер для потокової обробки

- **Redpanda Console**: Web UI для управління та моніторингу
- **Redpanda Connect**: Інструмент для інтеграції та трансформації даних
- **Kafka connect**: Інструмент для інтеграції та трансформації даних
- **KSQL**: Обробка потоків у реальному часі
- **Sample Data**: Генератори тестових даних для автомобільних транзакцій

## 🚀 Швидкий старт

### Передумови

- Docker і Docker Compose
- PowerShell (для Windows)
- Git

### Встановлення

1. **Клонування репозиторію**
   ```bash
   git clone https://github.com/Klimnyk/redpanda.git
   cd redpanda
   ```

2. **Налаштування змінних середовища**
   ```bash
   cp .env.example .env
   ```
   
   Відредагуйте `.env` файл та встановіть необхідні значення:
   ```bash
   REDPANDA_VERSION=v23.2.8
   REDPANDA_CONSOLE_VERSION=v2.3.1
   
   # Порти для Redpanda кластера
   KAFKA_0_EXTERNAL_PORT=9092
   ADMIN_0_EXTERNAL_PORT=9644
   SCHEMA_REGISTRY_0_EXTERNAL_PORT=8081
   PANDAPROXY_0_EXTERNAL_PORT=8082
   
   KAFKA_1_EXTERNAL_PORT=9093
   ADMIN_1_EXTERNAL_PORT=9645
   SCHEMA_REGISTRY_1_EXTERNAL_PORT=8083
   PANDAPROXY_1_EXTERNAL_PORT=8084
   
   KAFKA_2_EXTERNAL_PORT=9094
   ADMIN_2_EXTERNAL_PORT=9646
   SCHEMA_REGISTRY_2_EXTERNAL_PORT=8085
   PANDAPROXY_2_EXTERNAL_PORT=8086
   ```

3. **Запуск інфраструктури**
   ```bash
   docker-compose up -d
   ```

4. **Перевірка статусу**
   ```bash
   docker-compose ps
   ```

## 📁 Структура проекту

```
.
├── docker-compose.yaml          # Основна конфігурація Docker Compose
├── .env.example                 # Приклад змінних середовища
├── conf/                        # Конфігурації Redpanda
│   ├── .bootstrap.yaml          # Початкові налаштування кластера
│   ├── redpanda.yaml           # Основна конфігурація Redpanda
│   └── redpanda-console-config.yaml # Конфігурація Console
├── data/                        # Персистентні дані
├── docs/                        # Документація
│   └── transactions-v2.md       # Опис схеми транзакцій
├── examples/                    # Приклади та скрипти
│   ├── generate-sample-data.ps1 # Генератор тестових даних
│   ├── setup-ksql-stream-and-table.ps1 # Налаштування KSQL об'єктів
│   ├── run_dev.ps1             # Скрипт для тестування у режимі розробки
│   ├── ksql-*.json             # KSQL запити та конфігурації
│   ├── TransactionsData.json   # Приклад транзакційних даних
│   └── connectors-config-example/ # Конфігурації коннекторів
│       ├── mysql-connector.json    # MySQL Debezium коннектор
│       ├── pg-connector.json       # PostgreSQL коннектор
│       ├── pg-sink-unique.json     # PostgreSQL sink коннектор
│       └── iceberg-sink-connector.json # Apache Iceberg коннектор
└── redpanda-connect/           # Redpanda Connect конфігурації
    ├── connect.yaml            # Основна конфігурація Connect
    └── redpanda-gpt-connect.yaml # AI-інтеграція конфігурація
```

## 🔧 Використання

### Доступ до сервісів

- **Redpanda Console**: http://localhost:8080
- **KSQL Server**: http://localhost:8088
- **Schema Registry**: http://localhost:8081
- **Kafka REST Proxy**: http://localhost:8082

### Генерація тестових даних

```powershell
# Генерація 500 записів транзакцій Windows only
.\examples\generate-sample-data.ps1 -Count 500
```

### Налаштування KSQL

```powershell
# Створення потоків та таблиць Windows only
.\examples\setup-ksql-stream-and-table.ps1
```

### Робота з коннекторами

1. **MySQL коннектор**
   ```bash
   curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @examples/connectors-config-example/mysql-connector.json
   ```

2. **PostgreSQL коннектор**
   ```bash
   curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @examples/connectors-config-example/pg-connector.json
   ```


## 🛠️ Корисні команди

### Управління кластером

```bash
# Перезапуск кластера
docker-compose restart

# Перегляд логів
docker-compose logs -f redpanda-0

# Очищення даних
docker-compose down -v
```

### Робота з топіками

```bash
# Створення топіка
docker exec -it redpanda-0 rpk topic create readings --partitions 3

# Список топіків
docker exec -it redpanda-0 rpk topic list

# Перегляд повідомлень
docker exec -it redpanda-0 rpk topic consume readings
```

### KSQL запити

```sql
-- Створення потоку
CREATE STREAM invoice_stream (
  id INT, 
  "table" STRING, 
  invoice_num INT, 
  date STRING, 
  amount DOUBLE
) WITH (
  KAFKA_TOPIC='readings', 
  VALUE_FORMAT='JSON'
);

-- Створення агрегованої таблиці
CREATE TABLE invoice_summary AS 
SELECT 
  id, 
  COUNT(*) AS count, 
  SUM(amount) AS total_amount 
FROM invoice_stream 
GROUP BY id;
```

## 🐛 Усунення проблем

### Перевірка здоров'я кластера

```bash
docker exec -it redpanda-0 rpk cluster health
```

### Перевірка конфігурації

```bash
docker exec -it redpanda-0 rpk cluster config status
```

### Логи помилок

```bash
# Логи Redpanda
docker-compose logs redpanda-0

# Логи Connect
docker-compose logs redpanda-connect

# Логи Console
docker-compose logs redpanda-console
```

## 📚 Додаткові ресурси

- [Документація Redpanda](https://docs.redpanda.com/)
- [KSQL Reference](https://docs.ksqldb.io/)
- [Kafka connect](https://docs.confluent.io/platform/current/connect/index.html)
- [Redpanda Connect Documentation](https://docs.redpanda.com/redpanda-connect/)

