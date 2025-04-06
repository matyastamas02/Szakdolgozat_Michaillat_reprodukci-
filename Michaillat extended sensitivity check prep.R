
# here we calculate the changes in the alpha and omega parameters for the coefficient of recruitment cost 
#first with the original basic calibration
s <- 0.0095#job separation rate
d <- 0.999#discount factor
n <- 0.951#average employment rate
l <- 0.66# labor share
eta <- 0.233#efficiency of matching
nb <- 0.5#the elasticity of the matching function with respect to the unemployment rate
sz <- 0.32# % for the calculation of the recruiting cost
theta <- 0.446#average theta


s <- 0.0095
d <- 0.999
n <- 0.951
l <- 0.66
eta <- 0.233
nb <- 0.5
sz <- 0.54#The higher value from the literature Michaillat used
theta <- 0.446


s <- 0.0095
d <- 0.999
n <- 0.951
l <- 0.66
eta <- 0.233
nb <- 0.5
sz <- 0.64#a tenth higher estimate, which is in line with Hall and Milgrom (2008), quoted by Michaillat as saying that he believes the ove is similarly good
theta <- 0.446
alpha <- l*((1-d*(1-s))*sz/(eta*theta^(-nb)) +1)

omega <- l/(n^(1-alpha))

alpha

omega
#by the third estimate, the alpha is already larger than the omega, which means that the model no longer produces the expected dynamics

c <- omega*sz
c

#Hall and Milgrom's value of % of c
0.433/omega


























