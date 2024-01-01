test_that("qmd_doc_flatten extracts terminal components", {
  out <- parse_qmd("tests/testthat/example_doc.qmd")
  flattened_doc <- qmd_doc_flatten(out)
  expect_length(flattened_doc, 9)

  classes <- vapply(flattened_doc, function(x) class(x)[[1]], character(1))
  expect_equal(classes, c(
    "qmdparse_yaml", "qmdparse_text", "qmdparse_heading", "qmdparse_text",
    "qmdparse_heading", "qmdparse_text", "qmdparse_heading",
    "qmdparse_text", "qmdparse_code"
  ))
})

test_that("qmd_doc_flatten output roundtrip", {
  out <- parse_qmd("tests/testthat/example_doc.qmd")
  flattened_doc <- qmd_doc_flatten(out)
  qmd_doc_components <- lapply(flattened_doc, function(x) x$get_contents())

  expect_equal(
    unlist(qmd_doc_components),
    readLines("tests/testthat/example_doc.qmd")
  )

})
