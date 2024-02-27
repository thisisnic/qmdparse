test_that("extract_code extracts all code from a qmd", {

  out <- parse_qmd("qmds/simple_doc.qmd")
  out_code <- extract_code(out)
  expect_length(out_code, 1L)
  expect_true(inherits(out_code[[1]], "qmdparse_code"))

  expect_error(extract_code("qmds/simple_doc.qmd"), "`x` must be a qmdparse_obj object, not a character")

})
