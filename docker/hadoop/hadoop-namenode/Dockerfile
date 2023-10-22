#FROM hadoop-base:latest
#LABEL maintainer="MarcLamberti"
FROM apache/hadoop:3.3.6
ARG CLUSTER_NAME
ENV CLUSTER_NAME=$CLUSTER_NAME
ENV HDFS_CONF_DFS_NAMENODE_DATA_DIR=file:///hadoop/dfs/name

USER root
RUN mkdir -p /hadoop/dfs/name

COPY ./start-namenode.sh ./start-namenode.sh

RUN chmod +x ./start-namenode.sh

EXPOSE 9870

CMD [ "./start-namenode.sh" ]