# kraken-gaza-iliad

<https://ryanfb.github.io/kraken-gaza-iliad/groundtruth/>

This is a project for generating an edition-specific OCR training file for [Kraken](http://kraken.re/) for Theodorus Gaza's Attic paraphrase of the Iliad. By using the facing pages of the Iliad edition that are printed in the some font, we can quickly generate ground truth which can then (it is hoped) be used to train a model which can accurately OCR the Attic paraphrase.

## Data

The following Google Books volumes were used as source data:

* <http://books.google.com/books?id=QSE-AAAAcAAJ>
* <http://books.google.com/books?id=nyY-AAAAcAAJ>
* <http://books.google.com/books?id=vSY-AAAAcAAJ>
* <http://books.google.com/books?id=0SY-AAAAcAAJ>

Page images were extracted with [`pdfimages`](https://en.wikipedia.org/wiki/Pdfimages), Google logos were discarded, and the pages were automatically renamed. Images are available here: <https://github.com/ryanfb/kraken-gaza-iliad/releases/download/v1.0.0/gazapng.zip>

## Training

Run `make`, or override defaults with e.g.

    USE_DOCKER=false CUDA_DEVICE=cuda:0 make

## Trained model

A trained OCR model is provided in `gaza_best.mlmodel`.

## OCR Results

OCR results are available in hOCR format in the `hocr` directory. You can also browse the results here: <https://ryanfb.github.io/kraken-gaza-iliad/hocr/>
