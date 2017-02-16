FROM ubuntu:16.04
MAINTAINER Cristian Yones <cyones@sinc.unl.edu.ar>

# Web Demo Builder - Base Docker image for R 3.1

ENV bioconductor_url="http://bioconductor.org/packages/3.0/bioc/src/contrib/"
ENV bioconductor_data_url="http://www.bioconductor.org/packages/3.0/data/annotation/src/contrib/"

RUN echo deb http://cran.us.r-project.org/bin/linux/ubuntu trusty/ > /etc/apt/sources.list.d/r.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y --no-install-recommends \
      r-base \
      r-recommended \
      r-base-dev \
      imagemagick && \
    rm -rf /var/lib/apt/lists/*


# r packages
COPY install.r /

RUN Rscript /install.r BiocInstaller 1.16.5 ${bioconductor_url}
RUN Rscript /install.r preprocessCore 1.28.0 ${bioconductor_url}
RUN Rscript /install.r BiocGenerics 0.12.1 ${bioconductor_url}
RUN Rscript /install.r Biobase 2.26.0 ${bioconductor_url}
RUN Rscript /install.r DBI 0.3.1
RUN Rscript /install.r RSQLite 1.0.0
RUN Rscript /install.r S4Vectors 0.4.0 ${bioconductor_url}
RUN Rscript /install.r IRanges 2.0.1 ${bioconductor_url}
RUN Rscript /install.r GenomeInfoDb 1.2.5 ${bioconductor_url}
RUN Rscript /install.r AnnotationDbi 1.28.2 ${bioconductor_url}
RUN Rscript /install.r Rcpp 0.11.5
RUN Rscript /install.r RcppEigen 0.3.2.4.0
RUN Rscript /install.r minqa 1.2.4
RUN Rscript /install.r nloptr 1.0.4
RUN Rscript /install.r lme4 1.1-7
RUN Rscript /install.r profileModel 0.5-9
RUN Rscript /install.r brglm 0.5-9
RUN Rscript /install.r qvcalc 0.8-9
RUN Rscript /install.r relimp 1.0-4
RUN Rscript /install.r gnm 1.0-7
RUN Rscript /install.r gtools 3.4.1
RUN Rscript /install.r BradleyTerry2 1.0-6
RUN Rscript /install.r pbkrtest 0.4-2
RUN Rscript /install.r SparseM 1.6
RUN Rscript /install.r quantreg 5.11
RUN Rscript /install.r car 2.0-25
RUN Rscript /install.r plyr 1.8.1
RUN Rscript /install.r digest 0.6.8
RUN Rscript /install.r gtable 0.1.2
RUN Rscript /install.r stringi 1.1.2
RUN Rscript /install.r stringr 1.1.0
RUN Rscript /install.r reshape2 1.4.1
RUN Rscript /install.r RColorBrewer 1.1-2
RUN Rscript /install.r dichromat 2.0-0
RUN Rscript /install.r colorspace 1.2-6
RUN Rscript /install.r munsell 0.4.2
RUN Rscript /install.r labeling 0.3
RUN Rscript /install.r scales 0.4.1
RUN Rscript /install.r proto 0.3-10
RUN Rscript /install.r ggplot2 2.0.0
RUN Rscript /install.r iterators 1.0.7
RUN Rscript /install.r foreach 1.4.2
RUN Rscript /install.r caret 6.0-41
RUN Rscript /install.r doParallel 1.0.10
RUN Rscript /install.r e1071 1.6-4
RUN Rscript /install.r gridExtra 0.9.1
RUN Rscript /install.r Matrix 1.2-8
RUN Rscript /install.r segmented 0.5-1.1
RUN Rscript /install.r mixtools 1.0.2

# packages added by Cristian Yones
RUN Rscript /install.r magrittr 1.5
RUN Rscript /install.r registry 0.3
RUN Rscript /install.r RSpectra 0.12-0
RUN Rscript /install.r CORElearn 1.48.0
RUN Rscript /install.r cluster 2.0.5
RUN Rscript /install.r rpart 4.1-10
RUN Rscript /install.r R2HTML 2.3.2
RUN Rscript /install.r AUC 0.3.0
# igraph dependencies
RUN Rscript /install.r xtable 1.8-2
RUN Rscript /install.r pkgmaker 0.22
RUN Rscript /install.r registry 0.3
RUN Rscript /install.r rngtools 1.2.4
RUN Rscript /install.r gridBase 0.4-7
RUN Rscript /install.r NMF 0.20.6
RUN Rscript /install.r irlba 2.1.2
RUN Rscript /install.r igraph 1.0.1
RUN Rscript /install.r plotrix 3.6-4
# ggnetwork and dependencies
RUN Rscript /install.r statnet.common 3.3.0
RUN Rscript /install.r ggrepel 0.6.5
RUN Rscript /install.r network 1.13.0
RUN Rscript /install.r sna 2.4
# Create a new user "developer".
# It will get access to the X11 session in the host computer
ENV uid=1000
ENV gid=${uid}

COPY create_user.sh /

CMD /create_user.sh && sudo -H -u developer /bin/bash

