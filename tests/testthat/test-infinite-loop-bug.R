test_that("non-terminated code chunks raise error", {
  tf <- tempfile(fileext = ".qmd")

  invalid_doc <- '
---
title: "my document"
format: html
editor: source
---

Here is a floating bit of text. It is not in a section.

# Overview
In this document, I will talk about very little of meaning or merit.

```{r}
# this doc is invalid as I never closed this code chunk

# My First Real Section
This is where I tell you my grand idea!


'

  writeLines(invalid_doc, tf)

  readLines(tf)

  expect_error(
    qmdparse::parse_qmd(tf),
    regexp = "terminator not found"
  )
})
