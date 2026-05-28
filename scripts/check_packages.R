desc <- read.dcf("DESCRIPTION")
fields <- c("Depends", "Imports", "Suggests")
fields <- fields[fields %in% colnames(desc)]
pkgs <- unlist(strsplit(gsub("\\s+", "", desc[, fields]), ","))
pkgs <- gsub("\\(.*\\)", "", pkgs)
pkgs <- pkgs[!pkgs %in% c("R", "")]
missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
if (length(missing)) stop("Missing packages: ", paste(missing, collapse = ", "))
cat("All packages verified OK\n")