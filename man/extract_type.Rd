% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract.R
\name{extract_type}
\alias{extract_type}
\title{Extract all elements from a parsed Quarto markdown doc with a matching class}
\usage{
extract_type(x, type = c("yaml", "code", "text", "heading"))
}
\arguments{
\item{x}{qmdparse_obj object}

\item{type}{type of the element to extract; one of "yaml", "code", "text", "heading"}
}
\description{
Extract all elements from a parsed Quarto markdown doc with a matching class
}
