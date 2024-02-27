<!-- badges: start -->
  [![R-CMD-check](https://github.com/thisisnic/qmdparse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/thisisnic/qmdparse/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# qmdparse

A top-down recursive descent parser for qmd files.

Given this input `.qmd` file:

```
---
title: "my document"
format: html
editor: visual
---

# Overview

In this document, I will talk about very little of meaning or merit.

# My First Real Section

This is where I tell you my grand idea!

## A Mere Subsection

While I merely am a subsection, I am mighty!
I contain code and everything!

`` ```{r}
#| label: my_code
#| eval: TRUE
mean(mtcars$mpg)
`` ```
```

We can parse it like so:

``` r
library(qmdparse)
out <- parse_qmd("/home/nic/qmdparse/tests/testthat/qmds/simple_doc.qmd")
out[["My First Real Section"]][["A Mere Subsection"]]
#> ## A Mere Subsection
#> While I merely am a subsection, I am mighty!
#> I contain code and everything!
#> 
#> ```{r}
#> #| label: my_code
#> #| eval: TRUE
#> mean(mtcars$mpg)
#> ```
extract_code(out)
#> [[1]]
#> ```{r}
#> #| label: my_code
#> #| eval: TRUE
#> mean(mtcars$mpg)
#> ```
print_tree(out)
#> simple_doc.qmd
#>     ├──yaml
#>     ├──markdown
#>     ├──h1: Overview
#>         └──markdown
#>     └──h1: My First Real Section
#>         ├──markdown
#>         └──h2: A Mere Subsection
#>             ├──markdown
#>             └──code
```

## Installation

You can install the latest version of qmdparse from [github](https://github.com/thisisnic/qmdparse) with:

```r
library(devtools)
devtools::install_github("thisisnic/qmdparse")
```

## Similar work

Check out [parsermd](https://github.com/rundel/parsermd) for a `.rmd` parser based on C++ libraries or [lightparser](https://github.com/ThinkR-open/lightparser/) for a `.rmd` and `.qmd` parser based on knitr.
