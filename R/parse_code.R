#' Create AST for code block
#'
parse_code <- function(){

}

#' Create AST for non-code block
#'
parse_non_code <- function(){

}

parse_qmd <- function(file){
  file_contents <- readLines(file)

  file_annotations <- annotate_top_level(file_contents)
  top_level <- summarise_annotations(file_annotations)


  # TODO: parse code blocks
  # TODO: parse non-code blocks

  top_level
}



parse_qmd(file)
