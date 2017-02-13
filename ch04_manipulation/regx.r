## regx 練習,來自issac網站
## 1. http://issacstylelife.blogspot.tw/2016/05/r-regular-expression-function.html?m=1
## 2. http://stat545.com/block022_regular-expression.html
##### 1 ##########
text= c('Chrome CB3-111', 'Chrome 11 CB3-115', 'Chrome 15 CB5-122', 'xx10923', '13 EL1')
text
grep(pattern= 'Chrome', x= text)
grep(pattern="Chrome",x=text,value=T)
grep(pattern="Chrome",x=text,invert=T,value=T)

grepl(pattern="Chrome",x=text)

#取代 sub vs gsub
text
sub('C','C2',text)
gsub('C','C2',text)

# regexpr vs gregexpr

regexpr('e',text)

attr(regexpr("e", text), 'match.length')

gregexpr('Ch',text)



## strsplit
strsplit(text,split = "-1")
strsplit(text,split = " ")


## * , . , ?, {k}, {k,}

# *：和pattern符合至少0次
# +：和pattern符合至少1次
# ?：和pattern符合至多1次
# {k}：和pattern符合恰好k次
# {k,}：和pattern符合至少k次
# {p,q}：和pattern符合p到q次

text=c('86462233', '86462723', '27297668', '27222889', '27581575')
grep('272*', text, value=TRUE)
grep('272+',text,value=T)
grep('272{3}',text,value=T)
grep('272{2,}',text,value=T)
grep('272{1,2}',text,value=T)

##
# ^：pattern位於字串起首(亦即pattern前面為空)
# $：pattern位於字串結尾(亦即pattern之後為空)
# \b：matches the empty string at either edge of a word.
# \B：matches the empty string provided it is not at an edge of a word.


text=c('blue', 'enable', 'god bless you', 'It\'s an incredible book')
grep("ble$",text,value=T)
grep("\\bbl",text,value=T)
grep('\\Bbl', text, value=TRUE)


# [0-9] or [:number:] or \d :數字(Digits)
# \D or [^0-9]: 非數字
# [a-z] or [:lower:]: 小寫字母(Lower-case letters)
# [A-Z] or [:upper:]: 大寫字母(Upper-case letters)
# [a-zA-Z]or [:alpha:] or [A-z]: 字母(Alphabetic characters)
# [:alnum:]: 相當於[[:alpha:][:digit:]] or [A‐z0‐9] or [a-zA-Z0-9]
# [^a-zA-Z] :非字母的符號(Non-alphabetic characters)
# [:blank:]:空白(space)和tab 
# [:space:] or [ \t\n\r\f\v]: 各種空白符號(Space characters)
# [:punct:]: 標點符號(Punctuation Characters), ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
#     [:graph:]:相當於[[:alnum:][:punct:]]
#     [:print:]:可列印出的字符, 相當於[[:alnum:][:punct:]\\s]
#     \w: [[:alnum:]_] or [A‐z0‐9_]
#     \W: [^A‐z0‐9_]
#     \s: space ' '
#     \S: not space

### example

text=c('Firefox Setup Stub 46.0.1.exe', "Efficcess Free-5.21.0.520-win32", 'Adobe_Flash_Player_21.0.0.242_azo.exe')
inx= regexpr('[0-9]{2}\\.[0-9]', text)
ans = 
  sapply(text, function(s){
  sl= strsplit(s, split="[[:punct:][:blank:]]")
  appname= paste(grep('\\b[A-Z]', sl[[1]], value=TRUE), collapse=" ")
  return(appname)
})

grep('\\b[A-Z]',strsplit(text[2],split="[[:punct:][:blank:]]")[[1]],value=T)



##### 2 ############ 
(strings <- c("^ab", "ab", "abc", "abd", "abe", "ab 12"))

grep("ab.",strings,value=T)
grep("ab[c-e]",strings,value=T)
grep("ab[^c]",strings,value=T)
grep("^ab*",strings,value=T)
grep("^ab.",strings,value=T)
grep("\\^ab",strings,value=T)
grep("abc|abd",strings,value=T)
gsub("(ab) 12","\\1 34",strings)
