load_pancronos <- function(trace = FALSE)
{
  dt <- read.csv("data/field-names.csv")
  
  for (folder in list.dirs(path = "data", recursive = FALSE))
  {
    if(trace) cat(folder,":")
    
    dt <- rbind(dt, load_pancronos_dir(path = folder, trace = trace))
    
    if(trace) cat("\n")
  }
  
  for (field in names(dt))
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
    dt[,field] 
  }
  
  return(dt)
}

load_pancronos_dir <- function(path, trace = FALSE)
{
  fields <- scan("data/field-names.csv", character(), sep = ",")
  
  dt <- data.frame(matrix(ncol = length(fields), nrow = 0))
  
  for (entry in list.files(path, pattern = "*.csv"))
  {
    if(trace) cat(entry,":")
    
    temp <- read.csv(file.path(path, entry))
    
    new_row <- c()
    for (field in fields)
    {
      value <- as.character(temp[temp$FIELD == field,"VALUE"])
      if (is.null(value)){ value <- "" }
      new_row <- c(new_row, value)
    }
    dt <- rbind(dt, new_row)
    
    if(trace) cat("\n")
  }
  names(dt) <- fields
  
  return(dt)
}