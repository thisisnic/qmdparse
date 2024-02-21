test_that("detect_list_context works", {
  expect_true(detect_list_context("* Here is a list item", ""))
  expect_true(detect_list_context("  * I'm a little inset", ""))
  expect_true(detect_list_context("       * I'm even more inset", ""))

  expect_false(detect_list_context("I am not a list item", ""))
  expect_false(detect_list_context("*I don't have a space after the asterisk", ""))
  expect_false(detect_list_context("* I don't have a preceding blank line", "not blank"))
  expect_false(detect_list_context("I am not a list item", ""))
})
