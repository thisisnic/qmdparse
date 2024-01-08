scan_code <- function(file_contents, code_start, offset){
  code_end <- NULL

  # find the end of the code context
  while(is.null(code_end)){
    for(i in (code_start + 1):length(file_contents)){
      if(detect_code_context(file_contents[i])){
        code_end <- i
        break
      }
    }
  }

  # create a new code object
  qmdparse_code$new(
    code_start + offset,
    code_end + offset,
    file_contents[code_start:code_end]
  )

}
