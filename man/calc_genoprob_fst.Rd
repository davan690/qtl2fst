% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_genoprob_fst.R
\name{calc_genoprob_fst}
\alias{calc_genoprob_fst}
\title{Calculate conditional genotype probabilities and write to fst database}
\usage{
calc_genoprob_fst(cross, fbase, fdir = ".", map = NULL,
  error_prob = 0.0001, map_function = c("haldane", "kosambi", "c-f",
  "morgan"), lowmem = FALSE, quiet = TRUE, cores = 1, compress = 0,
  overwrite = FALSE)
}
\arguments{
\item{cross}{Object of class \code{"cross2"}. For details, see the
\href{https://kbroman.org/qtl2/assets/vignettes/developer_guide.html}{R/qtl2 developer guide}.}

\item{fbase}{Base of filename for fst database.}

\item{fdir}{Directory for fst database.}

\item{map}{Genetic map of markers. May include pseudomarker
locations (that is, locations that are not within the marker
genotype data). If NULL, the genetic map in \code{cross} is used.}

\item{error_prob}{Assumed genotyping error probability}

\item{map_function}{Character string indicating the map function to
use to convert genetic distances to recombination fractions.}

\item{lowmem}{If \code{FALSE}, split individuals into groups with
common sex and crossinfo and then precalculate the transition
matrices for a chromosome; potentially a lot faster but using more
memory.}

\item{quiet}{If \code{FALSE}, print progress messages.}

\item{cores}{Number of CPU cores to use, for parallel calculations.
(If \code{0}, use \code{\link[parallel:detectCores]{parallel::detectCores()}}.)
Alternatively, this can be links to a set of cluster sockets, as
produced by \code{\link[parallel:makeCluster]{parallel::makeCluster()}}.}

\item{compress}{Amount of compression to use (value in the range 0-100; lower values mean larger file sizes)}

\item{overwrite}{If FALSE (the default), refuse to overwrite any files that already exist.}
}
\value{
A list containing the attributes of \code{genoprob}
and the address for the created fst database.
Components are:
\itemize{
\item \code{dim} - List of all dimensions of 3-D arrays.
\item \code{dimnames} - List of all dimension names of 3-D arrays.
\item \code{is_x_chr} - Vector of all is_x_chr attributes.
\item \code{chr} - Vector of (subset of) chromosome names for this object.
\item \code{ind} - Vector of (subset of) individual names for this object.
\item \code{mar} - Vector of (subset of) marker names for this object.
\item \code{fst} - Path and base of file names for the fst database.
}
}
\description{
Uses a hidden Markov model to calculate the probabilities of the
true underlying genotypes given the observed multipoint marker
data, with possible allowance for genotyping errors.
}
\details{
This is like calling \code{qtl2::calc_genoprob()} and then
\code{fst_genoprob()}, but in a way that hopefully saves memory by
doing it one chromosome at a time.
}
\examples{
library(qtl2)
grav2 <- read_cross2(system.file("extdata", "grav2.zip", package="qtl2"))
gmap_w_pmar <- insert_pseudomarkers(grav2$gmap, step=1)
fst_dir <- file.path(tempdir(), "grav2_genoprob")
dir.create(fst_dir)
probs_fst <- calc_genoprob_fst(grav2, "grav2", fst_dir, gmap_w_pmar, error_prob=0.002)
}
\seealso{
\code{\link[qtl2:calc_genoprob]{qtl2::calc_genoprob()}}, \code{\link[=fst_genoprob]{fst_genoprob()}}
}
\keyword{utilities}
