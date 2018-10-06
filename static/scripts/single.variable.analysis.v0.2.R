
####################################
# Function to produce single variable analysis for multiple exposures
#
# Note: this function gives the equivalent of either the cctable or cstable 
#       commands in STATA
#
# Author: Daniel Gardiner
# Contact: daniel.gardiner@phe.gov.uk
# date: 08.02.2017
# 
# Edited by Zhian N. Kamvar to remove explicit library call within the function
# date: 2019-09-26

sva = function(data, outcome = "outcome", 
                  exposures = c("exposure1", "exposure2"), 
                  measure = "rr", verbose = F){
  # Description:
  # function to create a data.frame of risk ratio or odds ratio results 
  # for multiple exposures
  #
  # Args:   data: data.frame containing outcome and exposure data
  #      outcome: a character vector containing the name of the outcome column of 
  #               (1s and 0s) in data 
  #    exposures:  a character vector containing the names of exposure columns 
  #                of (1s and 0s) in data 
  #                   vectors of exposures (1s and 0s)
  #      measure:  a character vector indicating either rr (risk ratio)
  #                or 'or' (odds ratio)
  #
  #     verbose:   a logical vector, if TRUE gives full results
  #                                  if FALSE gives restricted results
  #
  # output: a data.frame containing results for each exposure
  
  out = as.numeric(data[, which(colnames(data) == outcome)])
  
  results = NULL
  
  for(i in exposures){
    exp = as.numeric(data[, which(colnames(data) == i)])
    
    t = epitools::epitable(exp, out)
    
    # calculate either risk ratios or odds ratios
    if(measure == "rr"){
      y = c(round(epitools::riskratio(t)$measure[2,], digits=3),
            round(epitools::riskratio(t)$p.value[2,2], digits=6))
    } else if (measure == "or") {
      y = c(round(epitools::oddsratio.wald(t)$measure[2,], digits=3),
            round(epitools::oddsratio.wald(t)$p.value[2,2], digits=6))
    } else { 
      stop("select measure either 'rr' (risk ratio) or 'or' (odds ratio)")
    }
    
    # put results into data.frame
    if(measure == "rr"){
      
      # total exposed
      te = sum(t[2, ])
      
      # exposed cases
      ec = t[2, 2]
      
      # exposed attack rate 
      ear = round(ec/te*100, digits=1)
      
      # total unexposed
      tu = sum(t[1, ])
      
      # unexposed cases
      uc = sum(t[1, 2])
      
      # unexposed attack rate
      uar = round(uc/tu*100, digits=1)
      
      y = data.frame(i, te, ec, ear, tu, uc, uar, t(y))
      
      colnames(y) = c("exposure", "exp", "exp.cases", "exp.AR",
                      "unexp", "unexp.cases", "unexp.AR",                 
                      "rr", "lower", "upper", "p.value")
    } else {
      
      # total cases
      tc = sum(t[, 2])
      
      # cases exposed
      ce = t[2, 2]
      
      # percentage of cases exposed
      pce = round(ce/tc*100, digits=1)
      
      # total controls
      tcon = sum(t[, 1])
      
      # controls exposed
      cone = t[2, 1]
      
      # percentage of controls exposed
      pcone = round(cone/tcon*100, digits=1)
      
      y = data.frame(i, tc, ce, pce, tcon, cone, pcone, t(y))
      
      colnames(y) = c("exposure", "cases", "cases.exp", "%cases.exp",
                      "controls", "controls.exp", "%controls.exp",                 
                      "or", "lower", "upper", "p.value")
    }
    results = rbind(results, y)   
  }
  
  # return either full are restricted results
  if(verbose){
    results
  } else {
    results = results[, c(1, 8:11)]
  }
  
  results
}  

####################################
# # examples
# 
# # define dummy data
# 
# set.seed(99)
# 
# df = data.frame(outcome = sample(c(0,1), 100, replace = T), 
#                 exposure1 = sample(c(0,1), 100, replace = T),
#                 exposure2 = sample(c(0,1), 100, replace = T))
# 
# # function examples
# 
# 
# sva(df, outcome = "outcome", exposures = c("exposure1", "exposure2"),
#        measure = "rr")
# 
# sva(df, outcome = "outcome", exposures = c("exposure1", "exposure2"),
#        measure = "or")
# 
# # using verbose = TRUE gives same output as you get in stata
# 
# sva(df, outcome = "outcome", exposures = c("exposure1", "exposure2"),
#        verbose = TRUE, measure = "rr")
# 
# sva(df, outcome = "outcome", exposures = c("exposure1", "exposure2"),
#        verbose = TRUE, measure = "or")
# 
# 
# 






