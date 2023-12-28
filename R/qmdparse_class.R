qmdparse <- function(path) {
  qmdparsedoc <- qmdparse_doc$new(path)
  qmdparsedoc
}

qmdparse_obj <- R6Class(
  "qmdparse_obj",
  public = list(
    get_children = function() {
      private$children
    },
    get_child = function(i) {
      private$children[[i]]
    }
  ),
  private = list(
    children = list()
  )
)

`[[.qmdparse_obj` <- function(x, i) {
  x$get_child(i)
}


qmdparse_doc <- R6Class(
  "qmdparse_doc",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(path) {
      private$path <- path
      private$type <- get_doc_type(path)
      private$contents <- readLines(path)
      private$set_children()
    },
    get_contents = function() {
      private$contents
    }
  ),
  private = list(
    path = NULL,
    contents = NULL,
    type = NULL,
    set_children = function() {
      tla <- annotate_top_level(private$contents)
      private$children <- extract_children(tla, private$contents)
    }
  )
)


get_doc_type <- function(path) {
  if (grepl("\\.rmd$", path, ignore.case = TRUE)) {
    "rmd"
  } else if (grepl("\\.qmd$", path, ignore.case = TRUE)) {
    "qmd"
  } else {
    rlang::abort("File type must be .Rmd or .qmd")
  }
}


qmdparse_block <- R6Class(
  "qmdparse_block",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
      private$set_children()
    }
  ),
  private = list(
    start = NULL,
    end = NULL,
    contents = NULL,
    set_children = function() {
      block <- annotate_block(private$contents)
      private$children <- extract_children(block, private$contents, private$start, private$end)
    }
  )
)

qmdparse_heading <- R6Class(
  "qmdparse_heading",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
    }
  ),
  private = list(
    start = NULL,
    end = NULL,
    contents = NULL
  )
)

qmdparse_paragraph <- R6Class(
  "qmdparse_paragraph",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
    }
  ),
  private = list(
    start = NULL,
    end = NULL,
    contents = NULL
  )
)

qmdparse_code <- R6Class(
  "qmdparse_code",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
    }
  ),
  private = list(
    start = NULL,
    end = NULL,
    contents = NULL
  )
)

qmdparse_yaml <- R6Class(
  "qmdparse_yaml",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
    }
  ),
  private = list(
    start = NULL,
    end = NULL,
    contents = NULL
  )
)

new_section <- function(type, start, end, contents) {
  switch(type,
    "code" = qmdparse_code$new(start, end, contents),
    "yaml" = qmdparse_yaml$new(start, end, contents),
    "text" = qmdparse_block$new(start, end, contents),
    "heading" = qmdparse_heading$new(start, end, contents),
    "paragraph" = qmdparse_paragraph$new(start, end, contents)
  )
}
