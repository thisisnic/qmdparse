test_that("print_tree prints tree correctly", {
  out <- parse_qmd("tests/testthat/example_doc.qmd")
  printed_tree <- capture.output(print_tree(out))
  expect_equal(
    printed_tree,
    c(
    "example_doc.qmd",
    "    ├──yaml section: ",
    "    ├──text!",
    "    ├──h1: Overview",
    "        └──text!",
    "    └──h1: My First Real Section",
    "        ├──text!",
    "        └──h2: A Mere Subsection",
    "            ├──text!",
    "            └──code!"
    )
  )
})
