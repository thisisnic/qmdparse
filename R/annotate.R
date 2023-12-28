#' Annotate top level sections
#'
#' @param file_contents vector of file contents
#' @return vector of annotations ("code", "yaml", or "text")
annotate_top_level <- function(file_contents) {
  file_annotations <- vector(mode = "character", length = length(file_contents))

  code_context <- FALSE
  yaml_context <- FALSE
  text_context <- FALSE

  # TODO: I think what we actually want to do here is to create the relevant objects
  # as a list which is then returned from this function, instead of all the fuckery
  # with parsing things and counting gaps
  #
  # Basically, what we want to do at a generic level is pass in a list of contexts,
  # which have names, signifiers, and a boolean signifying if they're encapsulated or not.
  # They also should have an end_char property that by default is set to the start_char,
  #  so we can do things like detect the end of a bulleted list
  #
  # If we are not in any context, we look for the start of one
  # If we are in an encapsulated context (yaml/code), we look for the end
  # If we are in an unencapsulated context (h1 heading), we look for the start of a new one



  for (i in seq_along(file_contents)) {
    line <- file_contents[i]

    if (code_context) {
      file_annotations[i] <- "code"
      if (grepl("^```", line)) {
        code_context <- FALSE
      }
      # non-code context
    } else if (yaml_context) {
      # we are still in a yaml context
      file_annotations[i] <- "yaml"
      # if we find a "---", then we end the yaml context
      if (grepl("^---", line)) {
        yaml_context <- FALSE
      }
      # if we are not in a yaml context but detect the start of one
    } else if (grepl("^---", line)) {
      yaml_context <- TRUE
      file_annotations[i] <- "yaml"
      # if we are not in a code context but detect the start of one
    } else if (grepl("^```", line)) {
      code_context <- TRUE
      file_annotations[i] <- "code"
    } else {
      file_annotations[i] <- "text"
    }
  }

  file_annotations
}

#' Summarise annotations
#'
#' @param annotations vector of annotations
#' @return tibble with start, end, and type columns
extract_children <- function(annotations, file_contents, start = 1, end = length(file_contents)) {
  run_lengths <- rle(annotations)
  end_indices <- cumsum(run_lengths$lengths) + (start - 1)

  # If the last index isn't the end of the file we need to go up to it
  if (end_indices[length(end_indices)] < end) {
    end_indices <- c(end_indices, end)
  }

  start_indices <- c(start, lag(end_indices) + 1)
  start_indices <- start_indices[-length(start_indices)]
  types <- annotations[start_indices - (start - 1)]
  lapply(seq_along(types), function(i) {
    new_section(
      types[i],
      start_indices[i],
      end_indices[i],
      contents = file_contents[start_indices[i]:end_indices[i]]
    )
  })
}

annotate_block <- function(contents) {
  block_annotations <- vector(mode = "character", length = length(contents))

  for (i in seq_along(contents)) {
    line <- contents[i]
    if (grepl("^#", line)) {
      block_annotations[i] <- "heading"
    } else {
      block_annotations[i] <- "paragraph"
    }
  }
  block_annotations
}
