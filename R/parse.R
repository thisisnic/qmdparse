#' @export
parse_qmd <- function(file){
  parsed_doc <- qmdparse_doc$new(file)
  parsed_doc
}

#' Annotate top level sections
#'
#' @param file_contents vector of file contents
#' @return vector of annotations ("code", "yaml", or "text")
parse_contents <- function(file_contents, offset = 0) {
  code_context <- FALSE
  yaml_context <- FALSE
  text_context <- FALSE
  section_context <- FALSE

  children <- list()
  current_context_start <- 1
  current_section_level <- 0

  for (i in seq_along(file_contents)) {
    line <- file_contents[i]

    prev_text_context <- text_context
    prev_section_context <- section_context
    prev_context_start <- current_context_start
    prev_section_level <- current_section_level

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
      # create relevant object for section context
    } else if (detect_heading(line)) {
      text_context <- FALSE
      section_context <- TRUE
      new_section_level <- detect_heading_level(line)
      # if we have a new heading, create an object for the previous one
      if (new_section_level == current_section_level) {
        children <- append(
          children,
          qmdparse_section$new(
            prev_context_start + offset,
            i - 1 + offset,
            file_contents[prev_context_start:(i- 1)], prev_section_level
          )
        )
        current_context_start <- i
      }
      if (prev_section_level == 0 && new_section_level > 0) {
        current_section_level <- new_section_level
      }
      # create relevant object for code context
    } else if (section_context) {
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
          file_contents[prev_context_start:(i - 1)]
        )
      )
      current_context_start <- i
    }
  }

  # if we still have a chunk open, close it
  if (section_context && i == length(file_contents)) {
    children <- append(
      children,
      qmdparse_section$new(
        prev_context_start + offset,
        i + offset,
        file_contents[prev_context_start:i],
        prev_section_level
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
