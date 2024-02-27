test_that("extract_named extracts all matching named elements from a qmd", {

  out <- parse_qmd("qmds/simple_doc_duplicate_sections.qmd")
  out_code <- extract_code(out)
  expect_length(out_code, 2L)
  expect_true(inherits(out_code[[1]], "qmdparse_code"))

  expect_error(extract_code("qmds/simple_doc_duplicate_sections.qmd"), "`x` must be a qmdparse_obj object, not a character")

})
