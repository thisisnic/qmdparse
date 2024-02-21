qmd_doc_flatten <- function(x) {
  components <- list()
  to_parse <- x$get_children()
  for (child in x$get_children()) {
    if (!has_children(child)) {
      components <- append(components, child)
    } else {
      components <- append(components, qmd_doc_flatten(child))
    }
  }
  components
}

#' @export
as.data.frame.qmdparse_doc <- function(x, ...) {
  flattened <- qmd_doc_flatten(x)
  df <- data.frame()

  level <- 0
  for (item in flattened) {
    if (inherits(item, "qmdparse_heading")) {
      level <- detect_heading_level(item$get_contents())
    }

    df <- rbind(
      df,
      data.frame(
        type = gsub("qmdparse_", "", class(item)[[1]]),
        level = level,
        contents = item$get_contents()
      )
    )
  }
  df
}
