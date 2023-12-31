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

```r
library(qmdparse)
out <- parse_qmd("tests/testthat/example_doc.qmd")
out[["My First Real Section"]][["A Mere Subsection"]]$get_contents()
#>  [1] ""                                            
#>  [2] "While I merely am a subsection, I am mighty!"
#>  [3] "I contain code and everything!"              
#>  [4] ""                                            
#>  [5] "```{r}"                                      
#>  [6] "#| label: my_code"                           
#>  [7] "#| eval: TRUE"                               
#>  [8] "mean(mtcars$mpg)"                            
#>  [9] "```"                                         
#> [10] "" 
print_tree(out)
#> .example_doc.qmd
#>     ├──yaml section: my document
#>     ├──text!
#>     ├──h1: Overview
#>         └──text!
#>     └──h1: My First Real Section
#>         ├──text!
#>         └──h2: A Mere Subsection
#>             ├──text!
#>             └──code!
```

