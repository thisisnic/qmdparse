test_that("print_tree prints tree correctly", {
  out <- parse_qmd("qmds/simple_doc.qmd")
  printed_tree <- capture.output(print_tree(out))
  expect_equal(
    printed_tree,
    c(
    "simple_doc.qmd",
    "    ├──yaml",
    "    ├──markdown",
    "    ├──h1: Overview",
    "        └──markdown",
    "    └──h1: My First Real Section",
    "        ├──markdown",
    "        └──h2: A Mere Subsection",
    "            ├──markdown",
    "            └──code"
    )
  )
})
