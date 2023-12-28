# qmdparse

```r
library(qmdparse)
out <- parse_qmd("tests/testthat/example_doc.qmd")
out[[2]][[3]]$get_contents()
```



TODO:

1. Write code to print AST based on nested objects
2. Write code to allow selection of objects based on headings (base on xml2?)
3. Write code to parse qmd contents into objects
