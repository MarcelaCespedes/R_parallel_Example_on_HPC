# R_parallel_Example_on_HPC
Example R code and sub file to run the Monty Hall 3-door game on a single CPU and also in parallel on 16 CPU's on QUT's HPC. Original R code and script file was kindly provided by Dr Justin Lee, for details and background on the Monty Hall game see [here](https://en.wikipedia.org/wiki/Monty_Hall_problem).

**IMPORTANT** There are many R parallelisation packages out there, ```mcapply()``` is an example of shared-memory parallelism which is what is used in this example, in that the whole job runs on one node and each HPC node has up to 24 CPU's. Please [email](hpc-support@qut.edu.au) HPC support staff to discuss advanced methods of parallelism, such as distributed memory. 

Folder **expected_output** contains the files the user should receive after a successful run of the Monthy Hall game in both parallel and on a single processor. The expected time to run the Monty Hall for 1e8 iteration on a single processor is approximately 16 minutes, and in parallel it takes approximately 30 second.
