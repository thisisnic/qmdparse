
chars <- list(
  "h" = "\u2500",
  "v" = "\u2502",
  "l" = "\u2514",
  "j" = "\u251C"
)

#TODO: set this up as a hierarchical list of qmdparse objects

test_object <- list(
  list(
    name = "my document",
    type = "qmd_doc",
    children = list(
      list(
        type = "h1_heading",
        name = "Overview",
        children = list(
          list(
            type = "paragraph",
            contents = "in this section, blah blah blah",
            children = list(
              NULL
            )
          )
        )
      ),
      list(
        type = "h1_heading",
        name = "h1 for the main body",
        children = list(
          list(
            type = "paragraph",
            contents = "in this section, blah blah blah",
            children = list(NULL)
          ),
          list(
            type = "h2_heading",
            name = "a subsection",
            children = list(
              list(
                type = "paragraph",
                contents = "this is a subsection, check me out!",
                children = list(NULL)
              )
            )
          )
        )
      ),
      list(
        type = "code",
        children = list(NULL)
      )
    )
  )
)





print_tree <- function(obj, level = 0){

  indent_level <- 4
  indent_char <- rep(" ", indent_level)

  for(i in seq_along(obj)){
    x <- obj[[i]]
    if(!is.null(x)){

      # If it's the last one we want the bendy corner symbol
      if(i == length(obj)){
        sym <- chars$l
      # Otherwise we want the junction symbol
      } else {
        sym <- chars$j
      }
      cat(rep(indent_char, level))
      cat(sym)
      cat(paste(rep(chars$h, 2)), collapse = "", sep = "")
      cat(x$type)
      if(is_named_section(x)){
        cat(": ")
        cat(x$name)
      }
      cat("\n")

    }

    if(has_children(x)){
      print_tree(x$children, level + 1)
    }
  }

}

has_children <- function(obj){
  !is.null(obj$children)
}

is_named_section <- function(obj){
  !is.null(obj$name)
}

print_tree(test_object)
