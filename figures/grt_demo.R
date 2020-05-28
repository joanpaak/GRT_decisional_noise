setwd("C:/Users/Joni/Documents/GitHub/GRT_decisional_noise/figures")




drawBivarDistr = function(mu, sigma = 1, poly = F, 
                          highlight_col = rgb(0.8, 0.3, 0.2, 0.7)){
  # For drawing circles.
  #
  # Mu: center of the circle
  # Sigma: spread of the circle
  # Poly: if true, a filled polygon is drawn
  #       if false, a depressing black line is drawn
  # highlight_col: color for the aforementioned polygon
  
  
  diam = qnorm(0.975) * sigma 
  theta = 0.01
  cumtheta = theta
  center = mu
  xcoords = center[1]
  ycoords = center[2] + diam
  i = 1
  
  while(cumtheta <= (2*pi)){
    xcoords[i+1] = xcoords[1] + diam * sin(cumtheta)
    ycoords[i+1] = ycoords[1] - diam * (1 - cos(cumtheta))
    cumtheta = cumtheta + theta
    i = i + 1
  }
  
  xcoords[i+1] = xcoords[1]
  ycoords[i+1] = ycoords[1]
  
  if(poly){
    polygon(xcoords, ycoords, col = highlight_col, border = NA)
  } else{
    points(xcoords, ycoords, type = "l")
  }
}


png(filename = "grt_demo.png", width = 480, height = 480)
plot(NULL, xlim = c(-5, 5), ylim = c(-5, 6), axes = F, 
     xlab = "Dimension 1", ylab = "Dimension 2")

axis(side = 1, at = c(-2, 2), label = c("Level 1", "Level 2"))
axis(side = 2, at = c(-2, 2), label = c("Level 1", "Level 2"))

drawBivarDistr(c(-2, -2), 1.25)
drawBivarDistr(c(2, -1), 1.25)
drawBivarDistr(c(-2, 2), 1.25)
drawBivarDistr(c(2, 3), 1.25)

abline(h = 0, lty = 2, col = "red")
abline(v = 0, lty = 2, col = "red")
dev.off()
