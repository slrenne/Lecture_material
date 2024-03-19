# simulation of Fick's law
n <- seq(from = 1, to = 5, length.out = 100)
t <- exp(n) # simulating thickness
a <- 4*pi*(max(t)-t)^2 #simulating the surface of the alveoli
v <- a*1/(t*1000) # 
plot(t, v, main = 'Diffusion as function of Thickness',
     log = 'x',  xlab = 'Thickness', ylab = 'Diffusion', 
     type = 'l', lwd = 3, col = 2)
