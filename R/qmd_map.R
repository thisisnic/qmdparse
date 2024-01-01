#' Map a function to particular sections of a qmd doc
#'
#' @param .path Path to qmd doc
#' @param .f Function to map
#' @param ... Additional arguments to pass to function
#' @param .type Type of section to map to
#'
#' @examples
#' qmd_map("tests/testthat/example_doc.qmd", stringi::str_count_words, .type = "text")
qmd_map <- function(.path, .f, ..., .type = "text"){
  parsed_doc <- parse_qmd(path)

  targets <- list()
  # extract the items of the correct type


  purrr::map(targets, .f, ...)

}

#TODO: decide if we want this or just level stuff actually
