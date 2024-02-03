# Copyright (c) 2022-2023 Wolfram Schneider, https://bbbike.org
#

MEMORY_ALL= 1024 768 640 512 384 256

DOCKER=		docker
DOCKER_FILE=	Dockerfile
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

check: memory
memory:
	for i in ${MEMORY_ALL}; \
	do \
	  time ${DOCKER} build --no-cache -m $${i}m -t ${DOCKER_TAG}/$$i -f ${DOCKER_FILE} . > ${MEMORY_LOG}.$$i 2>&1 & \
	done; wait
	${MAKE} -s images | grep ${DOCKER_TAG}
	${MAKE} log

log:
	tail -n3  $$(ls -tr ${MEMORY_LOG}.[0-9]*)
	
help:
	@echo "usage:"
	@echo ""
	@echo "make check"
	@echo "make log"
	@echo "make clean"

