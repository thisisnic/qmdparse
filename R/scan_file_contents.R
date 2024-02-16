#' Annotate top level sections
#'
#' @param file_contents vector of file contents
#' @param offset offset of where this section starts
#' @param level depth within doc
#' @return vector of annotations ("code", "yaml", or "text")
scan_file_contents <- function(file_contents, level, offset) {
  # container for items we find
  children <- list()

  # the highest index we've scanned
  scanned_max <- 0
  section_level <- level + 1

  # while we still have file to scan
  while (scanned_max < length(file_contents)) {
    current_scan <- scanned_max + 1
    # scan the next line
    line <- file_contents[current_scan]

    # if we detect yaml, create a new yaml context
    if (detect_yaml_context(line)) {
      yaml_context <- scan_yaml(file_contents, yaml_start = current_scan, offset)
      children <- append(children, yaml_context)
      scanned_max <- yaml_context$get_end() - offset
    # if we detect a section, create a new section context
    } else if (detect_heading(line, level = section_level)) {
      section_context <- scan_section(file_contents, section_start = current_scan, section_level, offset)
      children <- append(children, section_context)
      scanned_max <- section_context$get_end() - offset

    # if we detect code, create a new code context
    } else if (detect_code_context(line)) {
      code_context <- scan_code(file_contents, code_start = current_scan, offset)
      children <- append(children, code_context)
      scanned_max <- code_context$get_end() - offset

    # otherwise, create a new text context
    } else {
      text_context <- scan_text(file_contents, text_start = current_scan, offset)
      children <- append(children, text_context)
      scanned_max <- text_context$get_end() - offset
    }
  }

  names <- lapply(children, function(x) {
    x$get_name()
  })
  names(children) <- names
  children
}
