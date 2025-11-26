# Global knitr options

strict <- Sys.getenv("BOOKDOWN_STRICT") == "true"

knitr::opts_template$set(TAME_options = list(
  echo = TRUE,
  cache = FALSE,
  error = !strict,
  warning = TRUE,
  message = TRUE
))

TAME_template <- list(knitr::opts_template$get("TAME_options"))

do.call(knitr::opts_chunk$set, TAME_template)

# Ensure the output dir exists and set log path
dir.create("book", showWarnings = FALSE, recursive = TRUE)
ERROR_LOG_PATH <- file.path("book", "error.log")

# Initialize the log once per render
if (!isTRUE(getOption("tame2_error_log_initialized"))) {
  unlink(ERROR_LOG_PATH)
  cat(
    sprintf("# Error log started: %s\n\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
    file = ERROR_LOG_PATH, append = TRUE
  )
  options(tame2_error_log_initialized = TRUE)
}

# Append error entries
log_chunk_error <- function(msg, options) {
  label <- if (!is.null(options$label)) options$label else "<unnamed>"
  input <- tryCatch(knitr::current_input(), error = function(e) "<unknown-file>")
  cat(
    sprintf(
      "[%s] file=%s chunk=%s\n%s\n\n",
      format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), input, label, msg
    ),
    file = ERROR_LOG_PATH, append = TRUE
  )
}

default_error <- knitr::knit_hooks$get("error")

# Inline alert + log on any chunk error
knitr::knit_hooks$set(error = function(x, options) {

  if (isTRUE(options$suppress_error_alert)) {
    return (default_error(x, options))
  }

  log_chunk_error(x, options)
  title <- "**Error**"
  knitr::asis_output(paste(
    c(
      '\n\n:::{style="color:Crimson; background-color: SeaShell;"}',
      title,
      gsub('^## Error', '', x),
      '\n\n> Code below may be incorrect. We are working on a solution.',
      ':::'
    ),
    collapse = '\n'
  ))
})