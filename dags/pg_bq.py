"""Defining Aiflow DAG to move data from postgresql to Bigquery"""

import airflow.utils.dates
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.hooks.base import BaseHook
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.docker_operator import DockerOperator


default_args = {
    'owner': 'airflow'
}

dag = DAG(
    dag_id= "pg_to_bigquery",
    default_args=default_args,
    description= "Move data from postgres source to Bigquery data warehouse",
    schedule_interval= None
)

set_sling_bigquery = BashOperator(
    task_id='Setting_Bigquery_connection',
    bash_command="""
        sling conns set BIGQUERY type=bigquery project=olist-capstone dataset=olist_source key_file=/usr/local/airflow/secrets/olist-capstone-fca5288a13a7.json \
        && sling conns test BIGQUERY
    """,
    dag=dag
)

use_sling = BashOperator(
    task_id='Transferring_data',
    bash_command="""
        sling run -r /opt/airflow/dags/replication.yaml
    """,
    dag=dag
)

set_sling_bigquery >> use_sling
# sling run --src-conn SLING_PG --src-stream 'source.olist_order_payments_dataset' --tgt-conn BIGQUERY --tgt-object 'olist_ecommerce.payments' --mode incremental --primary-key 'order_id'