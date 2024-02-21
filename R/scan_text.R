scan_text <- function(file_contents, text_start, offset) {
  text_end <- length(file_contents)

  # find the end of the text context
  for (i in text_start:length(file_contents)) {
    if (i + 1 < length(file_contents)) {
      peek_next_line <- file_contents[i + 1]
      if (detect_section_context(peek_next_line) || detect_code_context(peek_next_line) ||
        detect_yaml_context(peek_next_line)) {
        text_end <- i
        break
      }
    }
  }

  # create a new text object
  qmdparse_text$new(
    text_start + offset,
    text_end + offset,
    file_contents[text_start:text_end]
  )
}
