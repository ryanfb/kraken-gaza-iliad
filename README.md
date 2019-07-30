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

Two trained OCR models are provided:

* `gaza_best_nfd.mlmodel` - trained using NFD normalization (Unicode canonical decomposition, i.e. accents and characters are treated as separate glyphs)
* `gaza_best_nfc.mlmodel` - trained using NFC normalization (Unicode canonical composition, i.e. accented characters are treated as a single glyph)

Each of these normalization techniques has different accuracy tradeoffs for Ancient Greek. Ideally, we could combine the output of both for greater combined accuracy.

## OCR Results

OCR results are available in hOCR format in the `hocr-nfd` and `hocr-nfc` directories. You can also browse the results here:

* <https://ryanfb.github.io/kraken-gaza-iliad/hocr-nfd/>
* <https://ryanfb.github.io/kraken-gaza-iliad/hocr-nfc/>
