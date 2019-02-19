all: gaza_best.mlmodel

extract: groundtruth/*.html
	docker run -it -v $(shell pwd):/data ryanfb/kraken ketos extract --output extract --normalization NFD groundtruth/*.html

gaza_best.mlmodel: extract
	time docker run --shm-size=256M -it -v $(shell pwd):/data ryanfb/kraken ketos train --output gaza extract/*.png

test: gaza_best.mlmodel
	docker run -it -v $(shell pwd):/data ryanfb/kraken ketos test -m gaza_best.mlmodel extract/*.png

clean:
	rm -rfv extract *.mlmodel
