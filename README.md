# kraken-gaza-iliad

<https://ryanfb.github.io/kraken-gaza-iliad/groundtruth/>

This is a project for generating an edition-specific OCR training file for [Kraken](http://kraken.re/) for Theodorus Gaza's Attic paraphrase of the Iliad. By using the facing pages of the Iliad edition that are printed in the some font, we can quickly generate ground truth which can then (it is hoped) be used to train a model which can accurately OCR the Attic paraphrase.

## Training

Run `make`, or override defaults with e.g.

    USE_DOCKER=false CUDA_DEVICE=cuda:0 make
