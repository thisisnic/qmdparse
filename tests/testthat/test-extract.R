test_that("extract_named extracts all matching named elements from a qmd", {

  out <- parse_qmd("qmds/simple_doc_duplicate_sections.qmd")
  out_code <- extract_named(out, "Overview")
  expect_length(out_code, 2L)

  expect_length(out_code[[1]]$get_contents(), 3L)
  expect_length(out_code[[2]]$get_contents(), 13L)

  expect_error(extract_named("qmds/simple_doc_duplicate_sections.qmd"), "`x` must be a qmdparse_obj object, not a character")

})

test_that("extract_code extracts all code from a qmd", {

  out <- parse_qmd("qmds/simple_doc.qmd")
  out_code <- extract_code(out)
  expect_length(out_code, 1L)
  expect_true(inherits(out_code[[1]], "qmdparse_code"))

  expect_error(extract_code("qmds/simple_doc.qmd"), "`x` must be a qmdparse_obj object, not a character")

})

test_that("extract_yaml extracts yaml from a qmd", {

  out <- parse_qmd("qmds/simple_doc.qmd")
  out_code <- extract_yaml(out)
  expect_length(out_code, 1L)
  expect_true(inherits(out_code[[1]], "qmdparse_yaml"))

  expect_error(extract_yaml("qmds/simple_doc.qmd"), "`x` must be a qmdparse_obj object, not a character")

})

test_that("extract_text extracts all text from a qmd", {

  out <- parse_qmd("qmds/simple_doc.qmd")
  out_code <- extract_text(out)
  expect_length(out_code, 5L)
  expect_true(all(map_lgl(out_code, ~inherits(.x, "qmdparse_text"))))

  expect_error(extract_text("qmds/simple_doc.qmd"), "`x` must be a qmdparse_obj object, not a character")

})

test_that("extract_headings extracts all headings from a qmd", {

  out <- parse_qmd("qmds/simple_doc.qmd")
  out_code <- extract_headings(out)
  expect_length(out_code, 3L)
  expect_true(all(map_lgl(out_code, ~inherits(.x, "qmdparse_heading"))))

  expect_error(extract_headings("qmds/simple_doc.qmd"), "`x` must be a qmdparse_obj object, not a character")

})
