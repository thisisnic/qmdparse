#' Extract all elements from a parsed Quarto markdown doc with a matching name
#'
#' @param x qmdparse_object object
#' @param name name of the element to extract
#' @export
extract_named <- function(x, name){

  if(!is_qmd_object(x)){
    rlang::abort(paste0("`x` must be a qmdparse_obj object, not a ", class(x)[[1]]))
  }

  flat_x <- qmd_doc_flatten(x, keep_parents = TRUE)

  flat_x[names(flat_x) == name]
}
