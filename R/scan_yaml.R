scan_yaml <- function(file_contents, yaml_start, offset) {
  yaml_end <- NULL

  # find the end of the yaml context
  while (is.null(yaml_end)) {
    for (i in (yaml_start + 1):length(file_contents)) {
      if (detect_yaml_context(file_contents[i])) {
        yaml_end <- i
        break
      }
    }
  }

  # create a new yaml object
  qmdparse_yaml$new(
    yaml_start + offset,
    yaml_end + offset,
    file_contents[yaml_start:yaml_end]
  )
}
