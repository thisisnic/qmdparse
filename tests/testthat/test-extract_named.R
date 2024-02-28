test_that("extract_named extracts all matching named elements from a qmd", {

  out <- parse_qmd("qmds/simple_doc_duplicate_sections.qmd")
  out_code <- extract_named(out, "Overview")
  expect_length(out_code, 2L)

  expect_length(out_code[[1]]$get_contents(), 3L)
  expect_length(out_code[[2]]$get_contents(), 13L)

  expect_error(extract_named("qmds/simple_doc_duplicate_sections.qmd"), "`x` must be a qmdparse_obj object, not a character")

})
