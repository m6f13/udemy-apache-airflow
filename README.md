# udemy-apache-airflow
Udemy Apache Airflow Hands on Guide

# Notes to run Airflow
## Links
- https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html
- https://airflow.apache.org/docs/helm-chart/stable/index.html

## Docker
start docker-compose
```shell
docker compose up airflow-init
```
after init:
```shell
airflow-init_1       | Upgrades done
airflow-init_1       | Admin user airflow created
airflow-init_1       | 2.7.2
start_airflow-init_1 exited with code 0
```
then start all services
```shell
docker-compose up
```
stop docker-compose
```shell
docker-compose down --volumes --rmi all
```

## Helm
### Airflow
in folder: helm/
```shell
helm repo add apache-airflow https://airflow.apache.org
helm upgrade --install airflow apache-airflow/airflow --namespace airflow --create-namespace
```
load chart locally in folder: helm/
```shell
helm pull apache-airflow/airflow --untar
```

## Deployment
### Airflow
```shell
helm upgrade --install airflow ./airflow -f ./airflow/values.yaml --namespace udemy-airflow --create-namespace
```

