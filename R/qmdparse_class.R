qmdparse <- function(path){
  qmdparsedoc <- qmdparse_doc$new(path)
  qmdparsedoc
}

qmdparse_obj <- R6Class(
  "qmdparse_obj",
  public = list(
    get_children = function(){
      private$children
    }
  ),
  private = list(
    children = list()
  )
)

qmdparse_doc <- R6Class(
  "qmdparse_doc",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(path) {
      private$path <- path
      private$type <- get_doc_type(path)
      private$doc_contents <- readLines(path)

    },
    get_doc_contents = function(){
      private$doc_contents
    }
  ),
  private = list(
    path = NULL,
    doc_contents = NULL,
    type = NULL
  )
)


get_doc_type <- function(path){
  if(grepl("\\.rmd$", path, ignore.case = TRUE)){
    "rmd"
  } else if(grepl("\\.qmd$", path, ignore.case = TRUE)){
    "qmd"
  } else {
    rlang::abort("File type must be .Rmd or .qmd")
  }
}


qmdparse_block <- R6Class(
  "qmdparse_block",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end){
      private$start = start
      private$end = end
    }
  ),
  private = list(
    start = NULL,
    end = NULL
  )
)

qmdparse_heading <- R6Class(
  "qmdparse_heading",
  inherit = qmdparse_obj
)

qmdparse_paragraph <- R6Class(
  "qmdparse_paragraph",
  inherit = qmdparse_obj
)

qmdparse_code <- R6Class(
  "qmdparse_code",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end){
      private$start = start
      private$end = end
    }
  ),
  private = list(
    start = NULL,
    end = NULL
  )
)

qmdparse_yaml <- R6Class(
  "qmdparse_yaml",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end){
      private$start = start
      private$end = end
    }
  ),
  private = list(
    start = NULL,
    end = NULL
  )
)

new_section <- function(type, start, end){
  switch(type,
         "code" = qmdparse_code$new(start, end),
         "yaml" = qmdparse_yaml$new(start, end),
         "text" = qmdparse_block$new(start, end)
  )
}
