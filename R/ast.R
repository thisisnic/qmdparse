chars <- list(
  "h" = "\u2500",
  "v" = "\u2502",
  "l" = "\u2514",
  "j" = "\u251C"
)

#' @title Print a tree of the parsed document
#' @description This function prints a tree of the parsed document to the console.
#' @param obj The parsed document
#' @param symbol The symbol to use for the current node
#' @param level The current level of the tree
#'
#' @export
print_tree <- function(obj, symbol = "", level = 0) {
  indent_level <- 2
  indent_char <- paste(rep("  ", indent_level * level), collapse = "")

  if (inherits(obj, "qmdparse_doc")) {
    cat(indent_char)
    cat(symbol)
    cat(obj$get_name(), fill = TRUE)
  }

  if (inherits(obj, "qmdparse_section")) {
    cat(indent_char)
    cat(symbol)
    cat("h")
    cat(obj$get_level())
    cat(": ")
    cat(obj$get_name(), fill = TRUE)
  }

  if (inherits(obj, "qmdparse_yaml")) {
    cat(indent_char)
    cat(symbol)
    cat("yaml")
    cat(obj$get_name(), fill = TRUE)
  }

  if (inherits(obj, "qmdparse_code")) {
    cat(indent_char)
    cat(symbol)
    cat("code", fill = TRUE)
  }

  if (inherits(obj, "qmdparse_text")) {
    cat(indent_char)
    cat(symbol)
    cat("markdown", fill = TRUE)
  }

  to_parse <- obj$get_children()

  # Don't print any whitespace elements
  if (!is.null(to_parse) && length(to_parse) > 0 && all(to_parse[[length(to_parse)]]$get_contents() == "")) {
    to_parse <- to_parse[1:(length(to_parse) - 1)]
  }

  level <- level + 1

  for (i in seq_along(to_parse)) {
    if (i == length(to_parse)) {
      symbol <- paste0(chars$l, paste0(rep(chars$h, 2), collapse = ""))
    } else {
      symbol <- paste0(chars$j, paste0(rep(chars$h, 2), collapse = ""))
    }

    child <- to_parse[[i]]
    print_tree(child, symbol, level)
  }
}

has_children <- function(obj) {
  length(obj$get_children()) > 0
}

is_named_section <- function(obj) {
  !is.na(obj$get_name())
}
