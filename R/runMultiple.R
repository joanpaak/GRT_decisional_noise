NSimulations = 100

decNoiseParam = list(correlation = 0.75,
                     sdev = 0.5)

simParam = list(NTrialsPerStim = 125,
                genTheta = c(0, 2, 0, 0, 2, 0, 0))

estimates = matrix(NaN, ncol = 7, nrow = NSimulations)

for(i in 1:NSimulations){
  print(i)
  
  # Sometimes a data set is genereted for which the L-BFGS-B
  # routine can't find an optimum. Usually it says that the 
  # gradient for rho isn't finite. 
  # 
  # This is avoided by discarding that particular data set and  
  # generating another one. Not optimal.
  
  while(TRUE){
    sim = runSimulation(decNoiseParam, simParam)
  
    fit =  tryCatch({
      optim(c(0, 2, 0, 0, 2, 0, 0), fn = negLogLikelihood,
            S = sim$S, R = sim$R, x = x, method = "L-BFGS-B",
            lower = c(-10, 0, -10, -10, 0, -10, -1),
            upper = c(100, 100, 100, 100, 100, 100, 1))},
      error = function(e){
      })
    if(!is.null(fit)){
      break
    } 
  }
  
  estimates[i,] = fit$par
}

estimates


mean(estimates[,7])
sd(estimates[,7])
