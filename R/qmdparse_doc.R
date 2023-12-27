qmdparse_doc <- R6Class(
  "qmdparse_doc",
  public = list(
    initialize = function(path) {
      private$path <- path
      private$type <- get_type(path)
      private$doc <- readLines(path)
    }
  ),
  private = list(
    path = NULL,
    doc = NULL,
    type = NULL,
    children = list()
  )
)


get_type <- function(path){
  if(grepl("\\.rmd$", path, ignore.case = TRUE)){
    "rmd"
  } else if(grepl("\\.qmd$", path, ignore.case = TRUE)){
    "qmd"
  } else {
    stop("Unknown file type")
  }
}
