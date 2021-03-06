a3 <- read.csv("/Users/tonyluo/UOFT/STA302/A3/a3data.csv",header=T)
summary(a3)

mycor <- function(a3){
panel.hist <- function(x, ...){
   usr <- par("usr"); on.exit(par(usr))
   par(usr = c(usr[1:2], 0, 1.5) )
   h <- hist(x, plot = FALSE)
   breaks <- h$breaks; nB <- length(breaks)
   y <- h$counts; y <- y/max(y)
   rect(breaks[-nB], 0, breaks[-1], y, col="lavender", ...)
   }
panel.cor <- function(x, y, digits=4, prefix="", cex.cor, ...){
   usr <- par("usr");
   on.exit(par(usr))
   par(usr = c(0, 1, 0, 1))
  
   txt1 <- format( cor(x,y), digits=digits )
   txt2 <- format(cor.test(x,y)$p.value , digits=digits)
 text(0.5,0.5, paste("r=",txt1, "\n P.val=",txt2), cex=0.8)
   }
 pairs(a3, lower.panel=panel.cor, cex =0.7, pch = 21, bg="steelblue",
          diag.panel=panel.hist, cex.labels = 1.1,
          font.labels=0.9, upper.panel=panel.smooth)
}
mycor


library(MASS) 

model1 <- lm(msrp~year+accelrate+mpg+mpgmpge, data = a3) #setup a linear regression model using price as denpendet variable and model year, accelerate rate, mpg and mpgmpge as independent variable.
bc=boxcox(model1,lambda=seq(-2,2,by=0.01)) #box-cox 
model2 <- lm(log(msrp)~year+accelrate+mpg+mpgmpge, data = a3)#setup a log transformation on model1.
summary(model1)
anova(model1)
summary(model2)
anova(model2)
AIC(model1)
AIC(model2)

par(mfrow=c(2,2))
plot(model1,which=1,main="Raw data") #plot the residual plot for raw data.
plot(model2,which=1,main="log(msrp)") #plot the residual plot for model after log transformation.

plot(model1,which=2) #plot the Normal Q-Q plot for raw data.
plot(model2,which=2) #plot the Normal Q-Q plot for model after log transformation.

confint(model2, level = 0.95) #check confidence interval for each beta in model after log transformation

newX=list(year = 2017, accelrate=5, mpg=50, mpgmpge = 50)#setup a new car model.
predict(model2, newdata=newX, interval = "confidence") #check the confidence interval for the new model.
predict(model2, newdata=newX, interval = "predict")#check the predict interval for the new model.

