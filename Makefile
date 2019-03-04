DOCKER_IMAGE ?= ryanfb/kraken
CUDA_DEVICE ?= cpu
USE_DOCKER ?= true
DOCKER_SHM ?= 256M

ifeq ($(USE_DOCKER),true)
	DOCKER_PREFIX=docker run --shm-size=$(DOCKER_SHM) -it -v $(shell pwd):/data $(DOCKER_IMAGE)
else
	DOCKER_PREFIX=
endif

all: gaza_best.mlmodel

extract: groundtruth/*.html
	$(DOCKER_PREFIX) ketos extract --output extract --normalization NFD groundtruth/*.html

gaza_best.mlmodel: extract
	time $(DOCKER_PREFIX) ketos train --device $(CUDA_DEVICE) --output gaza extract/*.png

test: gaza_best.mlmodel
	$(DOCKER_PREFIX) ketos test -m gaza_best.mlmodel extract/*.png

clean:
	rm -rfv extract *.mlmodel
