# udemy-apache-airflow
Udemy Apache Airflow Hands on Guide

# Notes to run Airflow
## Links
- https://docs.stackable.tech/home/stable/getting_started
- https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html
- https://airflow.apache.org/docs/helm-chart/stable/index.html
- https://artifacthub.io/packages/helm/runix/pgadmin4
## Spark
- https://spark.apache.org/docs/latest/running-on-kubernetes.html
## Hadoop
- https://artifacthub.io/packages/helm/apache-hadoop-helm/hadoop
- https://github.com/big-data-europe/docker-hadoop/blob/master/base/Dockerfile
## InfluxDB
- https://artifacthub.io/packages/helm/influxdata/influxdb
- https://github.com/influxdata/helm-charts

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

## NFS pvc mounting
```shell
sudo mount -t nfs -o vers=3 192.168.1.110:/data/udemy-airflow-airflow-dags-pvc-f6e964d7-b51c-4a87-8f8e-f39c2d6f6899 /home/martin/git/udemy-apache-airflow/nfs/dags
sudo umount -f -l /home/martin/git/udemy-apache-airflow/nfs/dags
```

## Helm
### prerequisite: Postgres & Redis
```shell
helm install --wait airflow-postgresql bitnami/postgresql --version 12.1.5 -n udemy-airflow --create-namespace \
    --set auth.username=airflow \
    --set auth.password=airflow \
    --set auth.database=airflow \
    --set global.storageClass=nfs-client \
    --set primary.persistence.storageClass=nfs-client \
    --set redReplicas.persistence.storageClass=nfs-client
```
```shell
helm install --wait airflow-redis bitnami/redis -n udemy-airflow --create-namespace \
    --set auth.password=redis \
    --version 17.3.7 \
    --set replica.replicaCount=1 \
    --set global.storageClass=nfs-client \
    --set master.persistence.storageClass=nfs-client \
    --set replica.persistence.storageClass=nfs-client \
    --set sentinel.persistence.storageClass=nfs-client
```
### Airflow
in folder: helm/
load chart locally in folder: helm/
```shell
helm pull apache-airflow/airflow --untar
```
```shell
helm repo add apache-airflow https://airflow.apache.org
helm upgrade --install airflow apache-airflow/airflow \
  --namespace udemy-airflow --create-namespace \
  --set data.metadataConnection.user=airflow \
  --set data.metadataConnection.pass=airflow \
  --set data.metadataConnection.protocol=postgresql \
  --set data.metadataConnection.host=airflow-postgresql.udemy-airflow.svc.cluster.local \
  --set data.metadataConnection.port=5432 \
  --set data.metadataConnection.db=airflow \
  --set data.metadataConnection.sslmode=disable \
  --set data.brokerUrl=redis://:redis@airflow-redis-master:6379/0 \
  --set workers.persistence.enabled=true \
  --set workers.persistence.size=10Gi \
  --set workers.persistence.storageClassName=nfs-client \
  --set trigger.persistence.enabled=true \
  --set trigger.persistence.size=10Gi \
  --set trigger.persistence.storageClassName=nfs-client \
  --set dagProcessor.enabled=true \
  --set redis.enabled=false \
  --set postgresql.enabled=false \
  --set config.core.load_examples=false \
  --set dags.persistence.storageClassName=nfs-client
```
### PGadmin
```shell
helm repo add runix https://helm.runix.net
```
in folder: helm/
```shell
helm pull runix/pgadmin4 --untar
```
```shell
helm upgrade --install pgadmin runix/pgadmin4 \
  --namespace udemy-airflow --create-namespace \
  --set service.port=80 \
  --set service.targetPort=80 \
  --set env.email=admin@domain.com \
  --set env.password=admin \
  --set persistentVolume.size=2Gi \
  --set persistentVolume.storageClass=nfs-client
```
### Hadoop
```shell

```

## Stackable
namespace = stackable
```shell
stackablectl operator install \
  commons=23.7.0 \
  secret=23.7.0 \
  zookeeper=23.7.0 \
  hdfs=23.7.0 --operator-namespace stackable
```
in folder: stackable/hdfs
```shell
kubectl apply -f zk.yaml
kubectl apply -f znode.yaml
kubectl apply -f hdfs.yaml
```