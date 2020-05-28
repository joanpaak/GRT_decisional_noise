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

# After each "block" 
#
#

NBlocks = 500
NTrials = 1

R = rep(0, NBlocks * NTrials); S = rep(0, NBlocks * NTrials)

for(i in 1:NBlocks){
  
  bias = mvtnorm::rmvnorm(1, mean = c(0, 0), sigma = 
                            matrix(c(1, 0.75,
                                     0.75, 1), 2, 2)) * 0.5
  
  p = genTableOfProbs(c(bias[1], 10, 0, bias[2], 10, 0, 0), x)
  
  for(j in 1:4){
    S = append(S, rep(j, NTrials))
    R = append(R, sample(1:4, NTrials, replace = T, prob = p[j,]))
  }
}


fit = 
optim(c(0, 2, 0, 0, 2, 0, 0), fn = negLogLikelihood,
      S = S, R = R, x = x, method = "L-BFGS-B",
      lower = c(-10, 0, -10, -10, 0, -10, -1),
      upper = c(100, 100, 100, 100, 100, 100, 1))

fit
