scan_code <- function(file_contents, offset) {
  code_end <- NULL
  max_line_scanned <- 1

  # find the end of the code context
  while (is.null(code_end) && max_line_scanned < length(file_contents)) {
    max_line_scanned <- max_line_scanned + 1
    if (detect_code_context(file_contents[max_line_scanned])) {
      code_end <- max_line_scanned
      break
    }
  }

  # catch if code_end is NULL
  if (is.null(code_end)) {
    rlang::abort("Invalid code section - terminator not found")
  }

  # create a new code object
  qmdparse_code$new(
    offset,
    code_end + offset,
    file_contents[1:code_end]
  )
}
