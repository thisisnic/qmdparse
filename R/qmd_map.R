#' Map a function to a qmd doc at a particular level
#'
#' @param .path Path to qmd doc
#' @param .f Function to map
#' @param ... Additional arguments to pass to function
#' @param level Level to map function to
#'
#' @examples
#' qmd_map("tests/testthat/example_doc.qmd", stringi::str_count_words, .level = 1)
qmd_map <- function(.path, .f, ..., .level = 0, .attribute = "cleaned_contents"){
  parsed_doc <- parse_qmd(path)

  targets <- list()
  # extract the items at the correct level


  purrr::map(targets, .f, ...)

}
