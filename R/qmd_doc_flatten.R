qmd_doc_flatten <- function(x){
  components <- list()
  to_parse <- x$get_children()
  for(child in x$get_children()){
    if(!has_children(child)){
      components <- append(components, child)
    } else {
      components <- append(components, qmd_doc_flatten(child))
    }
  }
  components
}
