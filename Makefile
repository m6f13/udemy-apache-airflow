.PHONY: build-base build-namenode run-base run-namenode push build-all

REPO = m6f13
POSTGRES_VERSION = 15.4-alpine
POSTGRES_NAME = custom-postgres
POSTGRES_PATH = docker/postgres
IMAGE_NAME_BASE = custom-hadoop-base
IMAGE_NAME_NAMENODE = custom-hadoop-namenode
HADOOP_VERSION = 3.3.6
DOCKER_PATH_BASE = docker/hadoop/hadoop-base/
DOCKER_PATH_NAMENODE = docker/hadoop/hadoop-namenode/
CLUSTER_NAME = hadoop_cluster

.ONESHELL:

build-postgres:
	@echo "Building Postgres image..."
	@docker build --build-arg POSTGRES_VERSION=$(POSTGRES_VERSION) -t $(REPO)/$(POSTGRES_NAME):$(POSTGRES_VERSION) $(POSTGRES_PATH)
	@echo "Postgres image built successfully."

build-base:
	@echo "Building base image..."
	@docker build --build-arg HADOOP_VERSION=$(HADOOP_VERSION) -t $(REPO)/$(IMAGE_NAME_BASE):$(HADOOP_VERSION) $(DOCKER_PATH_BASE)
	@echo "Base image built successfully."

build-namenode: build-base
	@echo "Building namenode image..."
	@docker build --build-arg CLUSTER_NAME=$(CLUSTER_NAME) -t $(REPO)/$(IMAGE_NAME_NAMENODE):$(HADOOP_VERSION) $(DOCKER_PATH_NAMENODE)
	@echo "Namenode image built successfully."

build-all: build-base build-namenode

run-base: build-base
	@echo "Running base container..."
	@docker run --rm -it $(REPO)/$(IMAGE_NAME_BASE):$(HADOOP_VERSION)

run-namenode: build-namenode
	@echo "Running namenode container..."
	@docker run --rm -it $(REPO)/$(IMAGE_NAME_NAMENODE):$(HADOOP_VERSION)

push: build-all
	#@echo "Pushing base image to repository..."
	#@docker push $(REPO)/$(IMAGE_NAME_BASE):$(HADOOP_VERSION)
	@echo "Pushing namenode image to repository..."
	@docker push $(REPO)/$(IMAGE_NAME_NAMENODE):$(HADOOP_VERSION)
	@echo "Images pushed successfully."

all: build-all push