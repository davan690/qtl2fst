# code related to clusters

# test if input is a prepared cluster (vs. just a number)
is_cluster <-
    function(cores)
{
    inherits(cores, "cluster") && inherits(cores, "SOCKcluster")
}

# number of cores being used
n_cores <-
    function(cores)
{
    if(is_cluster(cores)) return( length(cores) )
    cores
}

# set up a cluster
setup_cluster <-
    function(cores, quiet=TRUE)
{
    if(is_cluster(cores)) return(cores)

    if(is.null(cores) || is.na(cores)) cores <- 1
    if(cores==0) cores <- parallel::detectCores() # if 0, detect cores
    if(is.na(cores)) cores <- 1

    if(cores > 1 && Sys.info()[1] == "Windows") { # windows doesn't support mclapply
        cores <- parallel::makeCluster(cores)
        # the following calls on.exit() in the function that called this one
        # see https://stackoverflow.com/a/20998531
        do.call("on.exit",
                list(quote(parallel::stopCluster(cores))),
                envir=parent.frame())
    }
    cores
}

# run code by cluster (generalizes lapply, parLapply, and mclapply)
# (to deal with different methods on different architectures)
# if cores==1, just use lapply
cluster_lapply <-
    function(cores, ...)
{
    if(is_cluster(cores)) { # cluster object; use mclapply
        return( parallel::parLapply(cores, ...) )
    } else {
        if(cores==1) return( lapply(...) )
        return( parallel::mclapply(..., mc.cores=cores) )
    }
}
