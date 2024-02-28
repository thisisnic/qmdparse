#' Extract all elements from a parsed Quarto markdown doc with a matching name
#'
#' @param x qmdparse_obj object
#' @param name name of the element to extract
#' @export
extract_named <- function(x, name){

  if(!is_qmdparse_obj(x)){
    rlang::abort(paste0("`x` must be a qmdparse_obj object, not a ", class(x)[[1]]))
  }

  flat_x <- qmd_doc_flatten(x, keep_parents = TRUE)

  flat_x[names(flat_x) == name]
}


#' Extract all elements from a parsed Quarto markdown doc with a matching class
#'
#' @param x qmdparse_obj object
#' @param type type of the element to extract; one of "yaml", "code", "text", "heading"
extract_type <- function(x, type = c("yaml", "code", "text", "heading")){

  if(!is_qmdparse_obj(x)){
    rlang::abort(paste0("`x` must be a qmdparse_obj object, not a ", class(x)[[1]]))
  }

  type <- match.arg(type)
  class_name <- paste0("qmdparse_", type)

  flat_x <- qmd_doc_flatten(x, keep_parents = TRUE)

  flat_x[map_lgl(flat_x, ~inherits(.x, class_name))]
}

#' Extract all code from a parsed Quarto markdown doc
#'
#' @param x qmdparse_obj object
#' @export
extract_code <- function(x){
  extract_type(x, "code")
}

#' Extract yaml from a parsed Quarto markdown doc
#'
#' @param x qmdparse_obj object
#' @export
extract_yaml <- function(x){
  extract_type(x, "yaml")
}

#' Extract headings from a parsed Quarto markdown doc
#'
#' @param x qmdparse_obj object
#' @export
extract_headings <- function(x){
  extract_type(x, "heading")
}

#' Extract text from a parsed Quarto markdown doc
#'
#' @param x qmdparse_obj object
#' @export
extract_text <- function(x){
  extract_type(x, "text")
}
