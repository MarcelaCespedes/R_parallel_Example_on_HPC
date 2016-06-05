# R_parallel_Example_on_HPC
Example R code and sub file to run the Monty Hall 3-door game on a single CPU and also in parallel on 16 CPU's on QUT's HPC. Original R code and script file was kindly provided by Dr Justin Lee, for details and background on the Monty Hall game see [here](https://en.wikipedia.org/wiki/Monty_Hall_problem).

**Note:** No instructions are supplied on how to run R code on the HPC. We assume the user has access to and is familiar with usage of HPC facility. Instructions on how to submit an R code to the HPC can be found [here](https://gist.github.com/brfitzpatrick/132cedf8206ef45abe41f3552819a909).

Parallelisation of R code can be done quite simply by using a parallel version of ``lapply()``` called ```mclapply()```, which is provided by the parallel library, or ``foreach``` with ```%dopar%``` as provided by the ```doMC``` library. This is known as shared memory parallelism, as it only runs on a simple computer node (a node has many CPU cores which share access to the same memory).

To tell R how many CPU cores are available, you will need to set the ```MC_CORES``` environment variable in your PBS submission script to the number of cores requested on the node. For example, see ```mcmontyhall.sub```


**IMPORTANT** There are many R parallelisation packages out there, ```mcapply()``` is an example of shared-memory parallelism which is what is used in this example, in that the whole job runs on one node and each HPC node has up to 24 CPU's. Please see the HPC support services [webpage](http://www.itservices.qut.edu.au/researchteaching/hpc/) or email HPC staff to discuss advanced methods of parallelism, such as distributed memory. 

Folder **expected_output** contains the files the user should receive after a successful run of the Monthy Hall game in both parallel and on a single processor, just comment out the required lines of code to run via either processor allocation. The expected time to run the Monty Hall for 1e8 iteration on a single processor is approximately 16-20 minutes, and in parallel it takes approximately 30 seconds.
