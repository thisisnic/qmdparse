#' Parse a QMD document
#'
#' @param file path to file
#' @export
parse_qmd <- function(file) {
  parsed_doc <- qmdparse_doc$new(file)
  parsed_doc
}
