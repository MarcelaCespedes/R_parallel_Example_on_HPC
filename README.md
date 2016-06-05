# R_parallel_Example_on_HPC
Example R code and sub file to run the Monty Hall 3-door game on a single CPU and also in parallel on 16 CPU's on QUT's HPC. Original R code and script file was kindly provided by Dr Justin Lee, for details and background on the Monty Hall game see [here](https://en.wikipedia.org/wiki/Monty_Hall_problem).

**Note:** No instructions are supplied on how to run R code on the HPC. We assume the user has access to and is familiar with usage of HPC facility. Instructions on how to submit an R script file to the HPC can be found [here](https://gist.github.com/brfitzpatrick/132cedf8206ef45abe41f3552819a909).

Parallelisation of R code can be done quite simply by using a parallel version of `lapply()` called `mclapply()`, which is provided by the `parallel` library, or with the `foreach()` function with `%dopar%` as provided by the `doMC` library. This is known as shared memory parallelism, as it only runs on a single computer node (a node has many CPU cores which share access to the same memory).

To tell R how many CPU cores are available, you will need to set the `MC_CORES` environment variable in your PBS submission script to the number of cores requested on the node. For example, see `mcmontyhall.sub` file, on the 11th line
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

**The method illustrated in this repository***, call the `mclapply()` function. This uses the value in `MC_CORES` by default to determine how many cores to use, and parallelises the vector input across these cores. For example
```
result=mclapply(a_vector, FUN = your_parallel_function) 
```

The folder **expected_output** contains the files the user should receive after a successful run of the Monthy Hall game in both parallel and on a single processor, just comment out the required lines of code to run via either processor allocation. The expected time to run the Monty Hall for 1e8 iteration on a single processor is approximately 16-20 minutes, and in parallel it takes approximately 30 seconds.

Alternatively another method to parallelise in R is to call the `foreach()` function, but you first need to register how many CPU cores are available, with `registerDOMC(ncores)`. Then use `foreach` with `%dopar%` to parallelise the call to your function. For example
```
result <- foreach(i = (low_index:high_index)) %dopar% {
   your_parallel_function(i)
}
```
For more information on R parallelisation, see the following reference [here](http://www.glennklockwood.com/data-intensive/r/parallel-options.html). **Note:** for more advanced methods of parallelism, such as distributed memory algorithms, please see the HPC support [webpage](http://www.itservices.qut.edu.au/researchteaching/hpc/) and contact HPC [staff](http://www.itservices.qut.edu.au/researchteaching/hpc/contact.jsp).
