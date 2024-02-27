#' Extract all code from a parsed Quarto markdown doc
#'
#' @param x qmdparse_object object
#' @export
extract_code <- function(x){

  if(!is_qmd_object(x)){
    rlang::abort(paste0("`x` must be a qmdparse_obj object, not a ", class(x)[[1]]))
  }

  flat_x <- qmd_doc_flatten(x)
  purrr::keep(flat_x, .p = is_qmd_code)
}

is_qmd_code <- function(x){
  inherits(x, "qmdparse_code")
}

is_qmd_object <- function(x){
  inherits(x, "qmdparse_obj")
}
