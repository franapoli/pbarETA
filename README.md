# pbarETA

This is an extended version of the `txtProgressBar` function from the
utils package. Please refer to that documentation with
`help(txtProgressBar, utils)`. Use `library(pbarETA, warn=F)` to
override `utils::setTxtProgressBar` with `pbarETA::setTxtProgressBar`.

## Download and Installation

Latest version is available on Github at:

    https://github.com/franapoli/pbarETA

The package can be installed from the downloaded sources as
follows:

    install.packages("path-to-downloaded-source", repos=NULL)

devtools users can download and install at once the latest development
version from github as follows:

    install_github("franapoli/pbarETA")


## Example
```
pb <- txtProgressBar()
for(i in 1:10) {
  Sys.sleep(1)
  setTxtProgressBar(pb, i/10)
}
|===========                                                           |  16%, ETA 01:24
````


## Some notes:
+ Adding `library(pbarETA, warn=F)` to an existing script will provide ETA to any txtProgressBar object.
+ The estimation is accurate when different iterations tend to take the same amount of time.
+ Shows the significant part of Years:Months:Days:Hours:Minutes:Seconds.
+ Redrawn at least once per second (the original txtProgressBar is redrawn when values change).
+ Only tested for bar style=3 (default for pbarETA).
