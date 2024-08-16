# Airflow + Sling + DBT + BigQuery Pipeline

This repository contains an end-to-end data pipeline built using **Apache Airflow**, **Sling**, **DBT**, and **BigQuery**. The pipeline ingests CSV data into a Postgres-based eCommerce database, replicates it to Google BigQuery, and performs transformations using DBT. 

## Overview

1. **Custom Airflow Image**:  
   A custom `airflow-sling` Docker image was created by building a Dockerfile that adds the `sling` package on top of the Airflow image from Docker Hub.

2. **Docker Compose Services**:  
   In addition to the mandatory Airflow services, the `docker-compose.yml` file defines:
   - `ecommerce-db`: A Postgres service for the eCommerce database.
   - `sling-service`: A service that handles data ingestion from CSV files into the `ecommerce-db` using Sling.

3. **SLING Connector Setup**:  
   - A SLING connector to the eCommerce Postgres database is defined using environment variables set in the `docker-compose.yml` file.
   - All secrets are managed securely in a `.env` file, with only their corresponding keys referenced in the Docker Compose configuration.

4. **Data Ingestion**:  
   - Using the Sling service, a `replication.yaml` file is used to move CSV files into the eCommerce Postgres service.
   - Once the services are up (`docker-compose up`), the database is populated by running the `sling run` command.

5. **Airflow DAG Setup**:  
   The Airflow DAG automates data processing using the `BashOperator` to run Sling commands. The DAG consists of two primary tasks:
   - `set_sling_bigquery`: Configures the SLING-BigQuery connector.
   - `use_sling`: Moves data from the eCommerce Postgres database to BigQuery in **incremental full data upsert** mode, ensuring only new records are added and existing records are updated. This uses the table's primary key for deduplication.

6. **DBT Transformations**:  
   The data transformations are handled using **dbt-core** with the BigQuery adapter. The models are organized into subfolders:
   - **Staging Models**: Materialized as views.
   - **Intermediate Models**: Materialized as ephemeral for optimized query performance.
   - **Final Models**: Materialized as tables.

   - DBT configuration is stored in the `dbt_profile.yml` file, while the raw table definitions are documented in `sources.yml`.
   - `schema.yml` files in the `intermediate` and `final` subfolders document and test the models at each step.

## Folder Structure

```bash
├── dags/                 # Airflow DAGs,  also contains sling replication.yml file for postgres to bigquery
├── dbt/                     # DBT project files
│   ├── models/
│   │   ├── staging/         # DBT models materialized as views
│   │   ├── intermediate/    # DBT models materialized as ephemeral
│   │   ├── final/           # DBT models materialized as tables
│   │   ├── sources.yml      # Raw table metadata definitions
│   │   ├── schema.yml       # Model documentation and tests
├── sling_files/replication.yaml         # Sling replication file used at the start to load data from csv to postgresql
├── docker-compose.yml       # Docker Compose configuration
├── docker/Dockerfile               # Custom Airflow image setup
├── .env                     # Environment variables (secrets not committed)
└── README.md                # This readme file
```
## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed.
- `.env` file containing required secrets for database connections and services.

### Step 1: Build and Run Services

```bash
docker-compose up --build
```
This command will:
- Build the custom Airflow image with the Sling package.
- Start the `ecommerce-db` and `sling-service` for data ingestion.
- Launch Airflow for orchestrating the pipeline.

### Step 2: Populate the Database

Once the services are up, the Sling service will run the sling command to ingest CSV data into the eCommerce Postgres database.
### Step 3: Set Up Airflow DAG

Airflow will orchestrate the pipeline. Open airflow and trigger the DAG. The DAG includes:
- `set_sling_bigquery`: Sets up the SLING-BigQuery connector.
- `use_sling`: Replicates data from the Postgres database to BigQuery.

### Step 4: Run DBT Models

To run the DBT transformations, execute the following commands inside the `dbt` directory:

```bash
dbt run
```
- Staging models are materialized into views.
- Intermediate models are ephemeral for optimized performance.
- Final models are materialized as tables.

### Step 5: Run dbt Tests and Generate dbt Documentation
To run dbt test and generate documentation, run:

```bash
dbt test
dbt docs generate
```
## Additional Notes

- Ensure all required environment variables are configured in your `.env` file.
- The `docker-compose.yml` file is configured to handle secret management using environment keys.
- Use the `replication.yaml` files in both the `sling_files` and `dags` folders to define how Sling ingests data from CSV into Postgres, and how data is replicated to BigQuery in incremental full upsert mode.


