scan_section <- function(file_contents, section_start, level, offset) {
  # the section end is the end of the doc if we don't find another end
  section_end <- length(file_contents)
  code_context <- FALSE

  for (i in seq(section_start + 1, length(file_contents))) {
    line <- file_contents[i]

    if (detect_code_context(line)) {
      code_context <- !code_context
    }
    if (detect_heading(line, level) && !code_context) {
      section_end <- i - 1
      break
    }
  }
  qmdparse_section$new(
    start = section_start + offset,
    end = section_end + offset,
    contents = file_contents[section_start:section_end],
    level = level
  )
}
