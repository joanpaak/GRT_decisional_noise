setwd("C:/Users/Joni/Documents/GitHub/GRT_decisional_noise/R")

x = matrix(c(-1, -1,
             -1,  1,
             1, -1,
             1,  1), ncol = 2, nrow = 4, byrow = T)


genTableOfProbs = function(theta, x){
  mus = matrix(NaN, ncol = 2, nrow = 4)
  
  for(i in 1:4){
    mu_x = theta[1] + x[i,1] / (theta[2] * 2) + x[i,2] * theta[3]
    mu_y = theta[4] + x[i,2] / (theta[5] * 2) + x[i,1] * theta[6]
    
    mus[i,] = c(mu_x, mu_y)
  }
  
  p_ = matrix(NaN, ncol = 4, nrow =4)
  
  for(j in 1:4){
    for(i in 1:4) p_[j,i] = pbivnorm::pbivnorm(mus[j,1] * x[i,1], mus[j,2] * x[i,2], theta[7] * prod(x[i,]))
  } 
  
  return(p_)
}


negLogLikelihood = function(theta, S, R, x){
  
  ll = 0
  p = genTableOfProbs(theta, x)
  
  for(i in 1:length(S)){
    ll = ll + log(0.02 * 0.25 + 0.98 * p[S[i], R[i]])
  }
  
  return(-ll)
  
}

#### ####


runSimulation = function(decNoiseParam, simParam){
  
  NTrialsPerStim = simParam$NTrialsPerStim
  theta = simParam$genTheta
  
  R = rep(0, NTrialsPerStim * 4)
  S = rep(1:4, NTrialsPerStim)
  
  bias = mvtnorm::rmvnorm(NTrialsPerStim * 4, mean = theta[c(1, 4)], sigma = 
                            matrix(c(1, decNoiseParam$correlation,
                                     decNoiseParam$correlation, 1), 2, 2)) * decNoiseParam$sdev
  
  for(i in 1:(NTrialsPerStim * 4)){
  
    p = genTableOfProbs(c(bias[i,1], theta[2], theta[3], 
                          bias[i,2], theta[5], theta[6], theta[7]), x)
    R[i] = sample(1:4, 1, replace = T, prob = p[S[i],])
  }
  
  return(list(S = S, R = R))
}




