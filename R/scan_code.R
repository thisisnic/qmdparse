# could I just pass in the relevant subsection instead of the whole section?
# let's factor out code_start as it's unnecessary
scan_code <- function(file_contents, code_start, offset) {
  code_end <- NULL
  max_line_scanned <- 0

  # find the end of the code context
  while (is.null(code_end) && max_line_scanned < length(file_contents)) {
    for (i in (code_start + 1):length(file_contents)) {
      if (detect_code_context(file_contents[i])) {
        code_end <- i
        break
      }
      max_line_scanned <- max_line_scanned + 1
    }
  }

  # catch if code_end is NULL
  if (is.null(code_end)) {
    rlang::abort("Invalid code section - terminator not found")
  }

  # create a new code object
  qmdparse_code$new(
    code_start + offset,
    code_end + offset,
    file_contents[code_start:code_end]
  )
}
