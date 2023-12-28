#' @export
parse_qmd <- function(file){

  parsed_doc <- qmdparse_doc$new(file)
  parsed_doc
}



