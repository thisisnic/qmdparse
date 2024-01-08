detect_yaml_context <- function(line) {
  grepl("^---", line)
}

detect_code_context <- function(line) {
  grepl("^```", line)
}

detect_section_context <- function(line) {
  grepl("^#{1,6} ", line)
}

detect_heading <- function(line, level) {
  regex <- paste0("^#{", level, "} ")
  grepl(regex, line)
}

detect_heading_level <- function(line) {
  out <- regexpr("^#{1,6} ", line)
  attr(out, "match.length") - 1
}

detect_list_context <- function(line, prev_line){
  (prev_line == "") && grepl("^ *\\* ", line)
}
