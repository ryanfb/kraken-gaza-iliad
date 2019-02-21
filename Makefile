DOCKER_IMAGE ?= "ryanfb/kraken"

all: gaza_best.mlmodel

extract: groundtruth/*.html
	docker run -it -v $(shell pwd):/data $(DOCKER_IMAGE) ketos extract --output extract --normalization NFD groundtruth/*.html

gaza_best.mlmodel: extract
	time docker run --shm-size=256M -it -v $(shell pwd):/data $(DOCKER_IMAGE) ketos train --output gaza extract/*.png

test: gaza_best.mlmodel
	docker run -it -v $(shell pwd):/data $(DOCKER_IMAGE) ketos test -m gaza_best.mlmodel extract/*.png

clean:
	rm -rfv extract *.mlmodel
