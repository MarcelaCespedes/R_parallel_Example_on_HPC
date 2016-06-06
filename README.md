# Example of Running an R Job in Parallel on a PBS Managed HPC Facility
This repository contains examples of R code and a associated PBS submission file to run the Monty Hall 3-door game in serial on a single CPU core and also in parallel on 16 CPU cores.
This example is developed specifically for the QUT HPC facility Lyra.
The original R code and script files were kindly provided by Dr Justin Lee, for details and background on the Monty Hall game see [here](https://en.wikipedia.org/wiki/Monty_Hall_problem).

**Note:** No instructions are supplied on how to submit R jobs to the HPC.
We assume the user has access to and is familiar with the HPC facility.
Instructions on how to submit an R script file to the HPC can be found [here](https://gist.github.com/brfitzpatrick/132cedf8206ef45abe41f3552819a909).

Parallelisation of R code can be done quite simply by using a parallel version of `lapply()` called `mclapply()`, which is provided by the [`parallel`](https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf) package, or with the `foreach()` function with `%dopar%` as provided by the [`doMC`](https://cran.r-project.org/web/packages/doMC/index.html) package library. This is known as shared memory parallelism, as it only runs on a single computer node (a node has many CPU cores which share access to the same RAM).

To tell R how many CPU cores are available, you will need to set the `MC_CORES` environment variable in your PBS submission script to the number of cores requested on the node with the `ncpus=` element of the fourth line of this file.For example, see lines 4 and 11 of the `mcmontyhall.sub` file. 
```
#!/bin/bash -l
#PBS -N mcmonty
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=16:mem=120G
#PBS -j oe

cd $PBS_O_WORKDIR

module load R/3.2.4_gcc
# let the R parallel library know it has 16 cores available
export MC_CORES=16
# ensure external libraries called by threads don't utilise additional parallelism
export OMP_NUM_THREADS=1

# run the multicore montyhall code and save only the output to the .out file
R CMD BATCH --slave ./mcmontyhall.R mcmonty.out
```

In your R code you can retrieve this `MC_CORES` value with:
```
ncores <- getOption("mc.cores", 2L)
```

**The method illustrated in this repository**, calls the `mclapply()` function. This uses the value in `MC_CORES` by default to determine how many cores to use, and parallelises the vector input across these cores. For example
```
result=mclapply(a_vector, FUN = your_parallel_function) 
```

The folder **expected_output** contains the files the user should receive after a successful run of the Monthy Hall game in both parallel and in serial, just comment out the required lines of code to run via either CPU allocation. The expected time to run the Monty Hall for 1e8 iteration in serial on a single CPU core is approximately 16-20 minutes, and in parallel with the 1e8 iterations distributed across 16 CPU cores it takes approximately 30 seconds.

Alternatively, another method to use parallel computing in R is to call the `foreach()` function, but you first need to register how many CPU cores are available, with `registerDOMC(ncores)`. Once you have done this you may use `foreach` with `%dopar%` to parallelise the call to your function. For example
```
result <- foreach(i = (low_index:high_index)) %dopar% {
   your_parallel_function(i)
}
```
For more information on R parallelisation, see the following reference [here](http://www.glennklockwood.com/data-intensive/r/parallel-options.html). **Note:** for more advanced methods of parallelism, such as distributed memory algorithms, please see the HPC support [webpage](http://www.itservices.qut.edu.au/researchteaching/hpc/) and contact HPC [staff](http://www.itservices.qut.edu.au/researchteaching/hpc/contact.jsp).
