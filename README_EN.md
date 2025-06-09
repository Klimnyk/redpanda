# Redpanda

**Language**: [🇺🇦 Ukrainian](README.md) | **🇺🇸 English**

A project for demonstrating Redpanda (Apache Kafka-compatible streaming data platform) in the automotive trading domain. Includes Redpanda cluster setup, database connectors, KSQL processing, and integration examples.

## 🏗️ Architecture

The project includes:

- **Redpanda Cluster**: 3-node cluster for stream processing
- **Redpanda Console**: Web UI for management and monitoring
- **Redpanda Connect**: Tool for data integration and transformation
- **Kafka Connect**: Tool for data integration and transformation
- **KSQL**: Real-time stream processing
- **Sample Data**: Test data generators for automotive transactions

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- PowerShell (for Windows)
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Klimnyk/redpanda.git
   cd redpanda
   ```

2. **Configure environment variables**

   ```bash
   cp .env.example .env
   ```
   
   Edit the `.env` file and set the required values:

   ```bash
   REDPANDA_VERSION=v23.2.8
   REDPANDA_CONSOLE_VERSION=v2.3.1
   
   # Ports for Redpanda cluster
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

3. **Start the infrastructure**

   ```bash
   docker-compose up -d
   ```

4. **Check status**

   ```bash
   docker-compose ps
   ```

## 📁 Project Structure

```
.
├── docker-compose.yaml          # Main Docker Compose configuration
├── .env.example                 # Environment variables example
├── conf/                        # Redpanda configurations
│   ├── .bootstrap.yaml          # Initial cluster settings
│   ├── redpanda.yaml           # Main Redpanda configuration
│   └── redpanda-console-config.yaml # Console configuration
├── data/                        # Persistent data
├── docs/                        # Documentation
│   └── transactions-v2.md       # Transaction schema description
├── examples/                    # Examples and scripts
│   ├── generate-sample-data.ps1 # Test data generator
│   ├── setup-ksql-stream-and-table.ps1 # KSQL objects setup
│   ├── run_dev.ps1             # Development testing script
│   ├── ksql-*.json             # KSQL queries and configurations
│   ├── TransactionsData.json   # Sample transaction data
│   └── connectors-config-example/ # Connector configurations
│       ├── mysql-connector.json    # MySQL Debezium connector
│       ├── pg-connector.json       # PostgreSQL connector
│       ├── pg-sink-unique.json     # PostgreSQL sink connector
│       └── iceberg-sink-connector.json # Apache Iceberg connector
└── redpanda-connect/           # Redpanda Connect configurations
    ├── connect.yaml            # Main Connect configuration
    └── redpanda-gpt-connect.yaml # AI integration configuration
```

## 🔧 Usage

### Service Access

- **Redpanda Console**: <http://localhost:8080>
- **KSQL Server**: <http://localhost:8088>
- **Schema Registry**: <http://localhost:8081>
- **Kafka REST Proxy**: <http://localhost:8082>

### Test Data Generation

```powershell
# Generate 500 transaction records Windows only
.\examples\generate-sample-data.ps1 -Count 500
```

### KSQL Setup

```powershell
# Create streams and tables Windows only
.\examples\setup-ksql-stream-and-table.ps1
```

### Working with Connectors

1. **MySQL connector**

   ```bash
   curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @examples/connectors-config-example/mysql-connector.json
   ```

2. **PostgreSQL connector**

   ```bash
   curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @examples/connectors-config-example/pg-connector.json
   ```


## 🛠️ Useful Commands

### Working with Topics

```bash
# Create topic
docker exec -it redpanda-0 rpk topic create readings --partitions 3

# List topics
docker exec -it redpanda-0 rpk topic list

# View messages
docker exec -it redpanda-0 rpk topic consume readings
```

### KSQL Queries

```sql
-- Create stream
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

-- Create aggregated table
CREATE TABLE invoice_summary AS 
SELECT 
  id, 
  COUNT(*) AS count, 
  SUM(amount) AS total_amount 
FROM invoice_stream 
GROUP BY id;
```

### Cluster Management

```bash
# Restart cluster
docker-compose restart

# View logs
docker-compose logs -f redpanda-0

# Clean data
docker-compose down -v
```

## 🐛 Troubleshooting

### Check Cluster Health

```bash
docker exec -it redpanda-0 rpk cluster health
```

### Check Configuration

```bash
docker exec -it redpanda-0 rpk cluster config status
```

### Error Logs

```bash
# Redpanda logs
docker-compose logs redpanda-0

# Connect logs
docker-compose logs redpanda-connect

# Console logs
docker-compose logs redpanda-console
```

## 📚 Additional Resources

- [Redpanda Documentation](https://docs.redpanda.com/)
- [KSQL Reference](https://docs.ksqldb.io/)
- [Kafka Connect](https://docs.confluent.io/platform/current/connect/index.html)
- [Redpanda Connect Documentation](https://docs.redpanda.com/redpanda-connect/)