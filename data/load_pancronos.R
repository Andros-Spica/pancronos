load_pancronos <- function(trace = FALSE)
{
  fields <- get_field_names()
  
  dt <- fields
  
  for (folder in list.dirs(path = "data", recursive = FALSE))
  {
    if(trace) cat(folder,":")
    
    dt <- rbind(dt, load_pancronos_dir(path = folder, trace = trace))
    
    if(trace) cat("\n")
  }
  dt <- data.frame(lapply(dt, as.character), stringsAsFactors = F)
  dt <- dt[-c(1),]
  
  for (field in fields)
    {
    if (field == "Start" || field == "End")
    {
      dt[, field] <- as.numeric(as.character(dt[, field]))
    }
    else
    {
      if (field != "Comments" || field != "References")
      {
        dt[,field] <- factor(dt[,field])
      }
    }
  } 
  return(dt)
}

load_pancronos_dir <- function(path, trace = FALSE)
{
  fields <- get_field_names()
  
  files <- list.files(path, pattern = "*.csv")
  
  dt <- data.frame(matrix(ncol = length(fields), 
                          nrow = length(files)))
  dt <- data.frame(lapply(dt, as.character), stringsAsFactors = F)
  
  for (i in 1:length(files))
  {
    if(trace) cat(files[i],":")
    
    entry <- read.csv(file.path(path, files[i]))
    
    for (j in 1:length(fields))
    {
      value <- as.character(entry[entry$FIELD == fields[j],"VALUE"])
      if (is.null(value)){ value <- "" }
      dt[i,j] <- value
    }
    
    if(trace) cat("\n")
  }
  names(dt) <- fields
  
  return(dt)
}

get_field_names <- function()
{
  return(scan("data/field-names.csv", character(), sep = ","))
}
