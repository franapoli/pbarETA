# txtProgressBarETA
R txtProgressBar with Estimated Time of Arrival

This is a modification to the bundled txtProgressBar in R meant to add an estimation of remaining time. The estimation is computed as the average time required by previous iterations multiplied by the remaining iterations. Moreover, while txtProgressBar is not redrawn until its values change, txtProgressBarETA is updated at least once per second.
