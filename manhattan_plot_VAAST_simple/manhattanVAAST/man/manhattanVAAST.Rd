\name{manhattanVAAST}
\alias{manhattanVAAST}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  a function to plot VAAST simple reports.
}
\description{
  given some data and few lines parameters the package will generate a plot.
}
\usage{
manhattanVAAST(n.features=23000, sig.level=0.05, vaast.simple, title, sig.line = TRUE, axis.text = TRUE, custom.xlab = "index", sig.hjust = 0, sig.vjust = 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n.features}{
     the number of genes or features VAAST scored
}
  \item{sig.level}{
     The signficane level sig.level = 0.05
}    
\item{vaast.simple}{
   The File to do work on
}
  \item{title}{
     main title
}
  \item{sig.line}{
     Do you want the significance line in your plot?
}
  \item{axis.text}{
     Do you want the seqids on the plot?
}
  \item{custom.xlab}{
     Place your x-label here 
}
  \item{sig.hjust}{
     move the sig.line text horizontally + right - left (on same scale). use large numbers.
}
  \item{sig.vjust}{
     move the sig.line text vertically  + up - down (on same scale)
}
}
\details{
  no additional details
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Zev N. Kronenberg
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (n.features, sig.level, vaast.simple, title, sig.line = TRUE, 
    axis.text = TRUE, custom.xlab = "index", sig.hjust = 0, sig.vjust = 0) 
{
    dat <- read.table(vaast.simple, header = FALSE, skip = 1, 
        sep = "\t", fill = TRUE)
    dat <- dat[dat$V4 > 0, ]
    dat <- dat[, 1:6]
    dat <- dat[grep(dat$V5, pattern = "chr"), ]
    pos.dat <- strsplit(as.character(dat$V5), split = ":|;", 
        perl = TRUE)
    dat$seqid <- sapply(pos.dat, FUN = function(xx) {
        return(xx[[1]][1])
    })
    dat$pos <- as.numeric(as.character(sapply(pos.dat, FUN = function(xx) {
        return(xx[[2]][1])
    })))
    dat <- dat[order(dat$seqid, dat$pos), ]
    dat$index.vec <- cumsum(1:length(dat$pos))
    dat$len.correction1 <- unlist(tapply(dat$pos, INDEX = dat$seqid, 
        FUN = function(x) {
            c(max(x), rep(0, length(x) - 1))
        }, simplify = TRUE))
    dat$len.correction3 <- unlist(tapply(dat$pos, INDEX = dat$seqid, 
        FUN = function(x) {
            rep(max(x), length(x))
        }, simplify = TRUE))
    dat <- dat[order(-dat$len.correction3, dat$seqid, dat$pos), 
        ]
    dat$len.correction2 <- cumsum(dat$len.correction1)
    dat$relative.pos <- as.numeric(as.character(dat$len.correction2)) + 
        as.numeric(as.character(dat$pos))
    axis.name <- unique(dat$seqid)
    axis.name.pos.rel <- as.vector(tapply(dat$index, INDEX = dat$seqid, 
        FUN = function(x) {
            middle <- (max(x) + min(x))/2
        }))
    axis.name.pos.real <- sort(as.vector(tapply(dat$relative.pos, 
        INDEX = dat$seqid, FUN = function(x) {
            middle <- (max(x) + min(x))/2
        })))
    plot(y = -log10(as.numeric(as.character(dat$V3))), x = dat$relative.pos, 
        col = as.factor(dat$seqid), xaxt = "n", xlab = custom.xlab, 
        pch = 20, ylab = "-log10(p-value)", main = title)
    if (sig.line == TRUE) {
        abline(h = -log10(sig.level/n.features), lty = 2, lwd = 3, 
            col = "grey")
        text(x = (0.5 * max(dat$relative.pos)) + sig.hjust, y = 0.5 + 
            -log10(sig.level/n.features) + sig.vjust, "genome-wide sig. level", 
            cex = 1)
    }
    if (axis.text == TRUE) {
        axis(1, at = axis.name.pos.real, labels = axis.name, 
            las = 2)
    }
    if (axis.text == FALSE) {
        axis(1, at = axis.name.pos.real, labels = FALSE, las = 2)
    }
    return(dat)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
