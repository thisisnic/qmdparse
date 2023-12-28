# qmdparse

```r
library(qmdparse)
out <- parse_qmd("tests/testthat/example_doc.qmd")
out[[2]][[3]]$get_contents()
#> "in this section, blah blah blah" ""                                "## a subsection"                
```
