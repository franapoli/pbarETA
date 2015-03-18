# txtProgressBarETA
R txtProgressBar with Estimated Time of Arrival

This is a modification to the bundled txtProgressBar in R meant to add an estimation of remaining time. The estimation is computed as the average time required by previous iterations multiplied by the remaining iterations.

Features:
+ Redrawn at least once per second (the original txtProgressBar is not redrawn until its values change)
+ Shows the significant part of Years:Months:Days:Hours:Minutes:Seconds time (or HH:MM:SS at a minumum).

# NOTE
Currently implemented for bar style=3 only.

# Example
```
> iters <- 100
pb <- txtProgressBarETA(0,iters,style=3)
for(i in 1:iters) {
  Sys.sleep(1)
  setTxtProgressBar(pb, i)
}
|===========                                                           |  16%, ETA 01:24
````
