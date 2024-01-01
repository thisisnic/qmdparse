qmdparse <- function(path) {
  qmdparsedoc <- qmdparse_doc$new(path)
  qmdparsedoc
}

#' @export
qmdparse_obj <- R6Class(
  "qmdparse_obj",
  public = list(
    get_children = function() {
      private$children
    },
    get_child = function(i) {
      private$children[[i]]
    },
    get_contents = function() {
      private$contents
    },
    initialize = function(start, end, contents) {
      private$start <- start
      private$end <- end
      private$contents <- contents
    },
    get_name = function() {
      private$name
    },
    get_start = function() {
      private$start
    },
    get_end = function() {
      private$end
    },
    print = function(){
      print_tree(self)
    }
  ),
  private = list(
    children = list(),
    start = NULL,
    end = NULL,
    contents = NULL,
    name = ""
  )
)

#' @export
`[[.qmdparse_obj` <- function(x, i) {
  x$get_child(i)
}

#' @export
`[.qmdparse_obj` <- function(x, i) {
  x$get_children()[i]
}

#' @export
names.qmdparse_obj <- function(x) {
  names(x$get_children())
}

qmdparse_doc <- R6Class(
  "qmdparse_doc",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(path) {
      private$path <- path
      private$name <- basename(path)
      private$type <- get_doc_type(path)
      private$contents <- readLines(path)
      private$start = 1
      private$end = length(private$contents)
      private$set_children()
    },
    get_contents = function() {
      private$contents
    }
  ),
  private = list(
    path = NULL,
    type = NULL,
    set_children = function() {
      private$children <- parse_contents(private$contents)
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

qmdparse_section <- R6Class(
  "qmdparse_section",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents, level) {
      private$level <- level
      super$initialize(start, end, contents)
      if(self$has_heading()) {
        private$set_name()
      }
      private$set_children()
    },
    get_level = function() {
      private$level
    },
    has_heading = function() {
      regex <- paste0("^#{", private$level, "} ", collapse = "")
      grepl(regex, private$contents[1])
    }
  ),
  private = list(
    level = NULL,
    name = NA,
    set_name = function() {
      regex <- paste0("^#{", private$level, "} ", collapse = "")
      private$name <- gsub(regex, "", private$contents[1])
    },
    set_children = function() {

      if(self$has_heading()) {

        private$children <- c(
          qmdparse_heading$new(start = private$start, end = private$start, contents = private$contents[1]),
          parse_contents(private$contents[2:length(private$contents)], offset = private$start)
        )
      } else {
        private$children <- parse_contents(private$contents, offset = private$start)
      }

    }
  )
)

qmdparse_paragraph <- R6Class(
  "qmdparse_paragraph",
  inherit = qmdparse_obj,
  public = list()
)

qmdparse_code <- R6Class(
  "qmdparse_code",
  inherit = qmdparse_obj,
  public = list()
)

qmdparse_yaml <- R6Class(
  "qmdparse_yaml",
  inherit = qmdparse_obj,
  public = list(
    initialize = function(start, end, contents) {
      super$initialize(start, end, contents)
      private$parsed_contents <- yaml::read_yaml(text = private$contents)
    }
  ),
  private = list(
    parsed_contents = NULL
  )
)

qmdparse_text <- R6Class(
  "qmdparse_text",
  inherit = qmdparse_obj,
  public = list()
)

qmdparse_heading <- R6Class(
  "qmdparse_heading",
  inherit = qmdparse_obj,
  public = list()
)
