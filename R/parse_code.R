#' Create AST for code block
#'
parse_code <- function(){

}

#' Create AST for non-code block
#'
parse_non_code <- function(){

}

#' @export
parse_qmd <- function(file){

  parsed_doc <- qmdparse_doc$new(file)

  # TODO: parse code blocks
  # TODO: parse non-code blocks

  parsed_doc
}



