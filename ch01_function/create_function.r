
#################################################
## add func
#################################################
addnum <- function(x,y){
  s<-x+y
  return(s)
}

addnum(3,4)

addnum2 <- function(x,y){ x+y} ## no return ,but work!!! will return last expression by default.

addnum2(3,4)

## check func
body(addnum)

## formal
formals(addnum)

## args 
args(addnum2)

## helper 
?sum
help(sum)
example(sum)

#################################################
## Matching Arguments
#################################################

defaultArgs <- function(x,y=5){
  y<-y*2
  s<-x+y
  return(s)
}

defaultArgs(3)

defaultArgs(1:3)

defaultArgs(3,6)

defaultArgs(y=6,x=3)


## if /else 

functArgs <- function(x,y,type="sum"){
  if (type=="sum"){
    sum(x,y)
  }else if (type=="mean"){
    mean(x,y)
  }else{
    x*y
  }
}

functArgs(3,5)
functArgs(3,5,type = "mean")

## unspecified args
unspecarg <- function(x,y,...){
  x = x + 2
  y = x * 2
  sum(x,y,...)
}
unspecarg(3,5)
unspecarg(1,3,5,7,9)
unspecarg(1:3,10:13)



#################################################
## Environments 
#################################################


environment()
.GlobalEnv
globalenv()


identical(globalenv(),environment())

myenv <-new.env()
myenv
myenv$x <-3
ls(myenv)
ls()
environment(addnum)

environment(lm)


## compare env
addnum3 <- function(x,y){
  func1 <- function(x){
    print(environment())
  }
  func1(x)
  print(environment())
  x+y
}
addnum3(2,5)

## remove variables;
rm(myenv) # remove myenv 
rm(list=ls()) # remove all variables

## parent.env 

parentEnv = function(){
  e = environment()
  print(e)
  print(parent.env(e))
}
parentEnv()

#################################################
## lexical scoping (static binding)
#################################################

# 1.
x = 5;
tmpfunc = function(){
  x+3
}
tmpfunc() # 8

# 2.
x <-5
parentFunc <- function(){
  x<- 3
  childFunc <- function(){
    x
  }
  childFunc()
}
parentFunc() ## 3

# 3.

x<- 'string'
localasign <- function(x){
  x<-5
  x
}
localasign(x) # 5
x # string


# 4. global assign

x<- 'string'
globalassign <- function(x){
  x <<- 5
  x
}

globalassign(x) # 5
x # 5



#################################################
## Closure ?????
#################################################

addnum <- function(a,b){
  a+b
}
addnum(2,3) # 5

## 
(function(a,b){
  a+b
})(2,3) # 5

##
maxval <- function(a,b){
  (function(a,b){
    return(max(a,b))
  })(a,b)
}

maxval(c(1,10,5),c(2,11)) # 11

##
x<-c(1,10,100)
y<-c(2,4,6)
z<-c(30,40,60)
a<-list(x,y,z)
a # [[1]] 1,10,100 [[2]] 2,4,6 [[3]] 30,40,60

lapply(a, function(e){e[1]*10})

## 
x<- c(1,10,100)
func <- list(min1=function(e){min(e)},max1=function(e){max(e)})

func$min1(x) # 1 
func$max1(x) # 100
y <- c(1:100)
lapply(func,function(f){f(y)}) # $min1 1 ,$max1 100


## 
x<-c(1,10,100)
y<-c(2,4,6)
z<-c(30,60,90)
a<-list(x,y,z)

sapply(a,function(e){e[1]*10}) # 10 20 300 
lapply(a,function(e){e[1]*10}) # [[1]] 10 [[2]] 20 [[3]] 300


#################################################
## Performing Lazy evaluation 
#################################################

## lazy 

lazyfunc1 <- function(x,y){
  x
}
lazyfunc1(1,3) # 1
## lazy . error func
lazyfunc <- function(x,y){
  x +y
}
lazyfunc(2) # error
## 
lazyfunc4 <- function(x,y=4){
  x+y
}
lazyfunc4(3)

## fibonaccai

fibonaccai <- function(n){
  if (n==0) return(0)
  if (n==1) return(1)
  return(fibonaccai(n-1) + fibonaccai(n-2))
}

fibonaccai(10) # 55

## force

lazyfunc3 <- function(x,y){
  force(y)
  x
}
lazyfunc3(2) # raise Error in force(y) :arguments ....


## 
input_func <- function(x,func){
  func(x)
}
input_func(1:10,sum)


#################################################
## infix operator
#################################################

3 +5  #8

'+'(3,5) # infix operator , 8

3:5*2 -1 # 5,7,9

'-'('*'(3:5,2),1) # 5 7 9

## 
x<-c(1,2,3,3,2,1,2)
y<-c(2,5,3,3)
z<-c(4,3,2,2)

'%match%' <-function(a,b){
  intersect(a,b)
}
x %match% y # 2 3

##
'%diff%' <-function(a,b){
  setdiff(a,b)
}
x %diff% y # 1

x %match% y %match% z # 2 3

s<-list(x,y,z)
Reduce('%match%',s)

## overwrite + (dangerous)

'+' <-function(x,y) paste(x,y,sep='|')
x = '123'
y = '456'


#################################################
## Using replacement function
#################################################

x<-c(1,2,3)

names(x)<-c('a','b','c')
x  # a b c
   # 1 2 3

x<-'names<-'(x,value=c(1,2,3))
x # 1 2 3
  # 1 2 3 

##
x<-c(1,2,3)
"erase<-" <-function(x,value){
  x[!(x %in% value)]
}

erase(x) <-2

x ## 1 3

## erase

x<-c(1,2,3)

"erase<-"(x,value=c(2))

erase(x) = c(1,3)
x # 2


##  
x<-c(1,2,3)
y<-c(2,2,3)
z<-c(3,3,1)
a = list(x,y,z)

"erase<-"<-function(x,pos,value){
  x[[pos]] <- x[[pos]][!x[[pos]] %in% value]
  x
}

erase(a,2) <-c(2)
a



#################################################
## Error handling
#################################################

##  stop 
addnum <- function(a,b){
  if(!is.numeric(a) | !is.numeric(b)){
    stop("Either a or b is not numerics..")
  }
  a+b
}

addnum(2,"hello")

## warning 

addnum2 <- function(a,b){
  if(!is.numeric(a) | !is.numeric(b)){
    warning("Either a or b is not numerics..")
  }
  a+b
}

addnum2(2,"hello")
options(warn=2)

suppressWarnings(addnum2("hello world",3))


## try 
errormsg <- try(addnum("hi",3))
errormsg <- try(addnum("hi",3),silent = TRUE)
errormsg


## use try prevent stop 

iter <- c(1,2,3,'o',5)
res <- rep(NA,length(iter))

for (i in 1:length(iter)){
  res[i] = try(as.integer(iter[i]),silent=TRUE )
}

res # 

## stopifnot 

addnum3 <- function(a,b){
  stopifnot(!is.numeric(a),!is.numeric(b))
  a+b
}

addnum3('hi',3)

## tryCatch

dividenum <- function(a,b){
  result <- tryCatch({
    print(a/b)
  },error = function(e){
    # conditionMessage(e)
    if (!is.numeric(a) | !is.numeric(b)){
      print('Either a or b is not numeric')
    }
  },finally = {
    rm(a)
    rm(b)
    print('clean variables')
  })
}

dividenum(2,4)
dividenum(1)
dividenum('hi',2)

##



#################################################
## debuging
#################################################
debugfunc <- function(x,y){
  x<-y+2
  x
}

debugfunc(2)
debug(debugfunc) ## debug mode 
debugfunc(2) ## entering debuging...
undebug(debugfunc)## undebug mode
debugfunc(2)


## 
debugfunc2 <-function(x,y){
  x<-3
  browser()
  x<-y+2
  x
}

debugfunc2(2)

## using shift F9 
## c: continue 
## n: next 
## s: step 
## 
