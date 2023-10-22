.PHONY: build push

REPO = m6f13
IMAGE_NAME = custom-hadoop-namenode
IMAGE_VERSION = 3.3.6
DOCKER_PATH = docker/hadoop/hadoop-namenode/
CLUSTER_NAME = hadoop_cluster

build:
	@docker build --build-arg CLUSTER_NAME=$(CLUSTER_NAME) -t REPO/$(IMAGE_NAME):$(IMAGE_VERSION) $(DOCKER_PATH)

push: build
	@docker push $(REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)
