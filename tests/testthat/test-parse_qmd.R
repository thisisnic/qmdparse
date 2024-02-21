test_that("parse_qmd creates correct objects", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  expect_s3_class(out, "qmdparse_doc")

  expect_length(out$get_children(), 4)

  expect_s3_class(out[[1]], "qmdparse_yaml")
  expect_length(out[[1]]$get_children(), 0)

  expect_s3_class(out[[2]], "qmdparse_text")
  expect_length(out[[2]]$get_children(), 0)

  expect_s3_class(out[[3]], "qmdparse_section")
  expect_length(out[[3]]$get_children(), 2)
  expect_s3_class(out[[3]][[1]], "qmdparse_heading")
  expect_s3_class(out[[3]][[2]], "qmdparse_text")

  expect_s3_class(out[[4]], "qmdparse_section")
  expect_length(out[[4]]$get_children(), 3)
  expect_s3_class(out[[4]][[1]], "qmdparse_heading")
  expect_s3_class(out[[4]][[2]], "qmdparse_text")
  expect_s3_class(out[[4]][[3]], "qmdparse_section")

  expect_length(out[[4]][[3]]$get_children(), 4)
  expect_s3_class(out[[4]][[3]][[1]], "qmdparse_heading")
  expect_s3_class(out[[4]][[3]][[2]], "qmdparse_text")
  expect_s3_class(out[[4]][[3]][[3]], "qmdparse_code")
  expect_s3_class(out[[4]][[3]][[4]], "qmdparse_text")
})

test_that("parse_qmd creates correct names", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  expect_named(out, c("", "", "Overview", "My First Real Section"))
  expect_named(out[[1]], NULL)
  expect_named(out[[2]], NULL)
  expect_named(out[[3]], c("", ""))
  expect_named(out[[4]], c("", "", "A Mere Subsection"))
})

test_that("parse_qmd creates correct line numbers", {
  out <- parse_qmd("qmds/simple_doc.qmd")

  expect_equal(out$get_start(), 1)
  expect_equal(out$get_end(), 24)

  expect_equal(out[[1]]$get_start(), 1)
  expect_equal(out[[1]]$get_end(), 5)

  expect_equal(out[[2]]$get_start(), 6)
  expect_equal(out[[2]]$get_end(), 8)

  expect_equal(out[[3]]$get_start(), 9)
  expect_equal(out[[3]]$get_end(), 11)

  expect_equal(out[[4]]$get_start(), 12)
  expect_equal(out[[4]]$get_end(), 24)

  expect_equal(out[[3]][[1]]$get_start(), 9)
  expect_equal(out[[3]][[1]]$get_end(), 9)
  expect_equal(out[[3]][[2]]$get_start(), 10)
  expect_equal(out[[3]][[2]]$get_end(), 11)

  expect_equal(out[[4]][[1]]$get_start(), 12)
  expect_equal(out[[4]][[1]]$get_end(), 12)

  expect_equal(out[[4]][[2]]$get_start(), 13)
  expect_equal(out[[4]][[2]]$get_end(), 14)

  expect_equal(out[[4]][[3]]$get_start(), 15)
  expect_equal(out[[4]][[3]]$get_end(), 24)

  expect_equal(out[[4]][[3]][[1]]$get_start(), 15)
  expect_equal(out[[4]][[3]][[1]]$get_end(), 15)

  expect_equal(out[[4]][[3]][[2]]$get_start(), 16)
  expect_equal(out[[4]][[3]][[2]]$get_end(), 18)

  expect_equal(out[[4]][[3]][[3]]$get_start(), 19)
  expect_equal(out[[4]][[3]][[3]]$get_end(), 23)
})
