test_that("qmd_doc_flatten extracts terminal components", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  flattened_doc <- qmd_doc_flatten(out)
  expect_length(flattened_doc, 10)

  classes <- unname(map_chr(flattened_doc, ~class(.x)[[1]]))
  expect_equal(classes, c(
    "qmdparse_yaml", "qmdparse_text", "qmdparse_heading", "qmdparse_text",
    "qmdparse_heading", "qmdparse_text", "qmdparse_heading",
    "qmdparse_text", "qmdparse_code", "qmdparse_text"
  ))
})

test_that("qmd_doc_flatten can retain parent structures", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  flattened_doc <- qmd_doc_flatten(out, keep_parents = TRUE)
  expect_length(flattened_doc, 14)

  classes <- unname(map_chr(flattened_doc, ~class(.x)[[1]]))
  expect_equal(classes, c("qmdparse_doc", "qmdparse_yaml", "qmdparse_text", "qmdparse_section",
                          "qmdparse_heading", "qmdparse_text", "qmdparse_section", "qmdparse_heading",
                          "qmdparse_text", "qmdparse_section", "qmdparse_heading", "qmdparse_text",
                          "qmdparse_code", "qmdparse_text"))
})

test_that("qmd_doc_flatten output roundtrip", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  flattened_doc <- qmd_doc_flatten(out)
  qmd_doc_components <- lapply(flattened_doc, function(x) x$get_contents())

  expect_equal(
    unname(unlist(qmd_doc_components)),
    readLines("qmds/simple_doc.qmd", )
  )
})
