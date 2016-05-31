####################################################################
# R code written by Dr Justin Lee (QUT HPC staff)
# please email: marcela.cespedes@hdr.qut.edu.au for any enquiries
# Tuesday 17.5.2016
#
# simple parallel R example, adapted from code 
# http://www.r-bloggers.com/a-no-bs-guide-to-the-basics-of-parallelization-in-r/

# Monty Hall game background: https://en.wikipedia.org/wiki/Monty_Hall_problem

library(parallel)

# One simulation of the Monty Hall game
onerun <- function(.){ # Function of no arguments
    doors <- 1:3
    prize.door <- sample(doors, size=1)
    choice <- sample(doors, size=1)
 
    if (choice==prize.door) return(0) else return(1) # Always switch
}
 
# Many simulations of Monty Hall games
MontyHall <- function(runs, cores=getOption("mc.cores", 2L)){
    require(parallel)
    runtime <- system.time({
        avg <- mean(unlist(mclapply(X=1:runs, FUN=onerun, mc.cores=cores)))
    })[3]
    return(list(avg=avg, runtime=runtime))
}
 

# run the simulations and compare performance between single core and multicore
# single core simulation
#run1 <- rbind(c(MontyHall(1e8, cores=1), "cores"=1))

# multicore simulation
mccores <- getOption("mc.cores", 2L) 
run2 <- rbind(c(MontyHall(1e8), "cores"=mccores))

# output the results
rbind(run1, run2)
#run1
