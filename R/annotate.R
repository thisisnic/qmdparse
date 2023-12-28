#' Annotate top level sections
#'
#' @param file_contents vector of file contents
#' @return vector of annotations ("code", "yaml", or "text")
annotate_top_level <- function(file_contents) {
  file_annotations <- vector(mode = "character", length = length(file_contents))

  code_context <- FALSE
  yaml_context <- FALSE

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


annotate_text <- function(file_contents, sections) {
  text_sections <- sections[sections$type == "text", ]

  text_annotations <- list()

  map2(text_sections$start, text_sections$end, function(start, end) {
    for (i in start:end) {
      line <- file_contents[i]
      if (grepl("^#", line)) {
        text_annotations[length(text_annotations) + 1] <- list(line = i, type = "header")
      } else if (line == "") {
        text_annotations[length(text_annotations) + 1] <- list(line = i, type = "blank")
      } else {
        text_annotations[length(text_annotations) + 1] <- list(line = i, type = "text")
      }
    }
  })

  text_annotations
}
