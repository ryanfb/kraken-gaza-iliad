DOCKER_IMAGE ?= ryanfb/kraken
CUDA_DEVICE ?= cpu
USE_DOCKER ?= true
DOCKER_SHM ?= 256M
PARALLEL_ARGS ?= -j 4

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
	$(DOCKER_PREFIX) ketos test --device $(CUDA_DEVICE) -m gaza_best.mlmodel extract/*.png

gazapng.zip:
	wget 'http://rfbaumann.com/gazapng.zip'

gazapng: gazapng.zip
	unzip -o gazapng.zip

gazalines.zip:
	wget 'http://rfbaumann.com/gazalines.zip'

lines: gazapng gazalines.zip
	unzip -o gazalines.zip
	# Use this instead if you *really* want to regenerate line segmentation:
	# mkdir -p lines && parallel --will-cite --progress --bar --eta -u -j $(shell nproc) 'kraken -i {} lines/{/.}.json binarize segment > /dev/null' ::: gazapng/*.png

ocr: lines gaza_best.mlmodel
	mkdir ocr
	time $(DOCKER_PREFIX) parallel --will-cite --progress --bar --eta -u $(PARALLEL_ARGS) 'kraken --device $(CUDA_DEVICE) -i {} ocr/{/.}.txt binarize ocr --lines lines/{/.}.json -m gaza_best.mlmodel > /dev/null' ::: gazapng/*.png

hocr: lines gaza_best.mlmodel
	mkdir hocr
	time $(DOCKER_PREFIX) parallel --will-cite --progress --bar --eta -u $(PARALLEL_ARGS) 'kraken --device $(CUDA_DEVICE) -i {} hocr/{/.}.html binarize ocr --lines lines/{/.}.json -m gaza_best.mlmodel -h > /dev/null' ::: gazapng/*.png

clean:
	rm -rfv extract *.mlmodel
