dividenum <- function(a,b){
  result <-tryCatch({
    a/b
  },error=function(e){
    conditionMessage(e)
  })
  result
}

dividenum(1,0)
