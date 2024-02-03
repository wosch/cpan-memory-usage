# Copyright (c) 2022-2023 Wolfram Schneider, https://bbbike.org
#

MEMORY_ALL= 1024 768 640 512 384 256

DOCKER=	docker
DOCKER_TAG=	cpan/memory
MEMORY_LOG=	memory.log

all: help

clean:  clean-log
	if ${DOCKER} images | grep ${DOCKER_TAG} >/dev/null; then \
           ${DOCKER} rmi -f $$(${DOCKER} images | grep ${DOCKER_TAG} | awk '{ print $$3 }'); \
        fi
	${MAKE} images

distclean: clean

docker-images images:
	${DOCKER} images

clean-log:
	rm -f ${MEMORY_LOG}.[0-9]*

memory:
	for i in ${MEMORY_ALL}; \
	do \
	  time ${DOCKER} build --no-cache -m $${i}m -t ${DOCKER_TAG}/$$i -f Dockerfile . > ${MEMORY_LOG}.$$i & \
	done; wait
	${MAKE} -s images | grep ${DOCKER_TAG}
	${MAKE} log

log:
	tail -n3  $$(ls -tr ${MEMORY_LOG}.[0-9]*)
	
help:
	@echo "make memory"
	@echo "make log"
	@echo "make clean"
