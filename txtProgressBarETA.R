

txtProgressBarETA <-
    function (min = 0, max = 1, initial = 0, char = "=", width = NA, 
    title, label, style = 1, file = "")
{
    
    
    if (!identical(file, "") && !(inherits(file, "connection") && 
        isOpen(file))) 
        stop("'file' must be \"\" or an open connection object")
    if (!style %in% 1L:3L) 
        style <- 1
    .val <- initial
    .killed <- FALSE
    .nb <- 0L
    .pc <- -1L
    .time0 <- NA
    .timenow <- NA
    .firstUpdate <- T

    nw <- nchar(char, "w")
    if (is.na(width)) {
        width <- getOption("width")
        if (style == 3L) 
            width <- width - 10L
        width <- trunc(width/nw)
    }
    if (max <= min) 
        stop("must have 'max' > 'min'")
    up1 <- function(value) {
        if (!is.finite(value) || value < min || value > max) 
            return()
        .val <<- value
        nb <- round(width * (value - min)/(max - min))
        if (.nb < nb) {
            cat(paste(rep.int(char, nb - .nb), collapse = ""), 
                file = file)
            flush.console()
        }
        else if (.nb > nb) {
            cat("\r", paste(rep.int(" ", .nb * nw), collapse = ""), 
                "\r", paste(rep.int(char, nb), collapse = ""), 
                sep = "", file = file)
            flush.console()
        }
        .nb <<- nb
    }
    up2 <- function(value) {
        if (!is.finite(value) || value < min || value > max) 
            return()
        .val <<- value
        nb <- round(width * (value - min)/(max - min))
        if (.nb <= nb) {
            cat("\r", paste(rep.int(char, nb), collapse = ""), 
                sep = "", file = file)
            flush.console()
        }
        else {
            cat("\r", paste(rep.int(" ", .nb * nw), collapse = ""), 
                "\r", paste(rep.int(char, nb), collapse = ""), 
                sep = "", file = file)
            flush.console()
        }
        .nb <<- nb
    }
    up3 <- function(value, calledOnCreation=F) {
        timenow <- proc.time()[["elapsed"]]
        if(!calledOnCreation && .firstUpdate) {
            .time0 <<- timenow
            .timenow <<- timenow
            .firstUpdate <<- F
        }
        if (!is.finite(value) || value < min || value > max) 
            return()
        .val <<- value
        nb <- round(width * (value - min)/(max - min))
        pc <- round(100 * (value - min)/(max - min))

        if (nb == .nb && pc == .pc && timenow-.timenow<1)
            return()
        .timenow <<- timenow
        span <- timenow-.time0
        timeXiter <- span/(.val-min)
        ETA <- (max-.val) * timeXiter
        ETAstr <- formatTime(ETA)

        
        cat(paste(c("\r  |", rep.int(" ", nw * width + 6)), collapse = ""), 
            file = file)
        cat(paste(c("\r  |", rep.int(char, nb), rep.int(" ", 
            nw * (width - nb)), sprintf("| %3d%%", pc), ", ETA ", ETAstr), collapse = ""), 
            file = file)
        flush.console()
        .nb <<- nb
        .pc <<- pc
    }
    getVal <- function() .val
    kill <- function() if (!.killed) {
        cat("\n", file = file)
        flush.console()
        .killed <<- TRUE
    }
    up <- switch(style, up1, up2, up3)
    up(initial, T)

    structure(list(getVal = getVal, up = up, kill = kill), class = "txtProgressBar")
}

formatTime <- function(seconds)
    {
        if(seconds == Inf || is.nan(seconds) || is.na(seconds))
            return("NA")

        seconds <- round(seconds)
        
        sXmin <- 60
        sXhr <- sXmin*60
        sXday <- sXhr*24
        sXweek <- sXday*7
        sXmonth <- sXweek*4.22
        sXyear <- sXmonth*12

        years <- floor(seconds/sXyear)
        seconds <- seconds - years*sXyear
        
        months <- floor(seconds/sXmonth)
        seconds <- seconds - months*sXmonth
        
        weeks <- floor(seconds/sXweek)
        seconds <- seconds - weeks*sXweek
        
        days <- floor(seconds/sXday)
        seconds <- seconds - days*sXday
        
        hours <- floor(seconds/sXhr)
        seconds <- seconds - hours*sXhr
        
        minutes <- floor(seconds/sXmin)
        seconds <- seconds - minutes*sXmin
        
        ETA <- c(years, months, days, hours, minutes, seconds)

        startst <- which(ETA>0)[1]
        if(is.na(startst))
            startst <- 6
        starts <- min(startst,4)
        fmtstr <- rep("%02d",length(ETA))[startst:length(ETA)]
        fmtstr <- paste(fmtstr, collapse=":")

        
        return(do.call(sprintf, as.list(c(as.list(fmtstr), ETA[startst:length(ETA)])) ))
        
       }

if(F)
    {
        ## short-iterations test        
        iters <- 10000000
        pb <- txtProgressBarETA(0,iters,style=3)
        for(i in 1:iters) {
            setTxtProgressBar(pb, i)
            a <- runif(1000000)
        }

        ## fixed-time-iterations test
        iters <- 60*10
        pb <- txtProgressBarETA(1,iters,style=3)
        system.time(
        for(i in 1:iters) {
            setTxtProgressBar(pb, i)
            Sys.sleep(3)
        }
        )
        
    }
    
