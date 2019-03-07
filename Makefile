DOCKER_IMAGE ?= ryanfb/kraken
CUDA_DEVICE ?= cpu
USE_DOCKER ?= true
DOCKER_SHM ?= 256M

ifeq ($(USE_DOCKER),true)
	DOCKER_PREFIX=docker run --shm-size=$(DOCKER_SHM) -it -v $(shell pwd):/data $(DOCKER_IMAGE)
else
	DOCKER_PREFIX=
endif

.PHONY: all clean test

all: gaza_best.mlmodel

extract: groundtruth/*.html
	$(DOCKER_PREFIX) ketos extract --output extract --normalization NFD groundtruth/*.html

gaza_best.mlmodel: extract
	time $(DOCKER_PREFIX) ketos train --device $(CUDA_DEVICE) --output gaza extract/*.png

test: gaza_best.mlmodel
	$(DOCKER_PREFIX) ketos test -m gaza_best.mlmodel extract/*.png

gazapng.zip:
	wget 'http://rfbaumann.com/gazapng.zip'

gazapng: gazapng.zip
	unzip -o gazapng.zip

ocr: gazapng gaza_best.mlmodel
	mkdir ocr
	$(DOCKER_PREFIX) parallel --will-cite --progress 'kraken -i {} ocr/{/.}.txt binarize segment ocr -m gaza_best.mlmodel' ::: gazapng/*.png

clean:
	rm -rfv extract *.mlmodel
