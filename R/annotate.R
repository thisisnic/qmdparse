#' Annotate top level sections
#'
#' @param file_contents vector of file contents
#' @return vector of annotations ("code", "yaml", or "text")
parse_contents <- function(file_contents, offset = 0) {
  code_context <- FALSE
  yaml_context <- FALSE
  text_context <- FALSE
  heading_context <- FALSE

  children <- list()
  current_context_start <- 1
  current_heading_level <- 0

  for (i in seq_along(file_contents)) {
    line <- file_contents[i]

    prev_text_context <- text_context
    prev_heading_context <- heading_context
    prev_context_start <- current_context_start
    prev_heading_level <- current_heading_level

    # create relevant object for yaml context
    if (detect_yaml_context(line) && !yaml_context) {
      yaml_context <- TRUE
      text_context <- FALSE
    } else if (detect_yaml_context(line) && yaml_context) {
      yaml_context <- FALSE
      children <- append(
        children,
        qmdparse_yaml$new(
          current_context_start + offset,
          i + offset,
          file_contents[current_context_start:i]
        )
      )
      current_context_start <- i + 1
    } else if (yaml_context) {
      next
      # create relevant object for heading context
    } else if (detect_heading_context(line)) {
      text_context <- FALSE
      heading_context <- TRUE
      new_heading_level <- detect_heading_level(line)
      # if we have a new heading, create an object for the previous one
      if (new_heading_level == current_heading_level) {
        children <- append(
          children,
          qmdparse_heading$new(
            prev_context_start + offset,
            i - 1 + offset,
            file_contents[prev_context_start:(i- 1)], prev_heading_level
          )
        )
        current_context_start <- i
      }
      if (prev_heading_level == 0 && new_heading_level > 0) {
        current_heading_level <- new_heading_level
      }
      # create relevant object for code context
    } else if (heading_context) {
      next
    } else if (detect_code_context(line) && !code_context) {
      code_context <- TRUE
      text_context <- FALSE
    } else if (detect_code_context(line) && code_context) {
      code_context <- FALSE
      children <- append(
        children,
        qmdparse_code$new(
          current_context_start + offset,
          i + offset,
          file_contents[current_context_start:i]
        )
      )
      current_context_start <- i + 1
    } else if (code_context) {
      next
    } else {
      text_context <- TRUE
    }

    # If we've switched from text context to non-text context, create a text object
    if (prev_text_context && !text_context) {
      children <- append(
        children,
        qmdparse_text$new(
          prev_context_start + offset,
          i - 1 + offset,
          file_contents[prev_context_start:i - 1]
        )
      )
      current_context_start <- i
    }
  }

  # if we still have a chunk open, close it
  if (heading_context && i == length(file_contents)) {
    children <- append(
      children,
      qmdparse_heading$new(
        prev_context_start + offset,
        i + offset,
        file_contents[prev_context_start:i],
        prev_heading_level
      )
    )
  } else if (text_context && i == length(file_contents)) {
    children <- append(
      children,
      qmdparse_text$new(
        prev_context_start + offset,
        i + offset,
        file_contents[prev_context_start:i]
      )
    )
  }

  names <- lapply(children, function(x) {
    x$get_name()
  })
  names(children) <- names
  children
}

detect_yaml_context <- function(line) {
  grepl("^---", line)
}

detect_code_context <- function(line) {
  grepl("^```", line)
}

detect_heading_context <- function(line) {
  grepl("^#{1,6} ", line)
}

detect_heading_level <- function(line) {
  out <- regexpr("^#{1,6} ", line)
  attr(out, "match.length") - 1
}
