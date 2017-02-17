FROM ubuntu:14.04
MAINTAINER Cristian Yones <cyones@sinc.unl.edu.ar>

#ENV http_proxy="http://proxy.unl.edu.ar:8000"

RUN echo deb http://cran.r-project.org/bin/linux/ubuntu trusty/ > /etc/apt/sources.list.d/r.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | sudo apt-key add -

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y \
      r-base \
      r-recommended \
      r-base-dev \
      imagemagick \
      curl \
      libcurl4-gnutls-dev && \
    apt-get clean && apt-get autoclean

RUN > CRAN.R
RUN echo 'install.packages("Rcpp", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("Matrix", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("RSpectra", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("AUC", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("network", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("sna", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("ggplot2", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("ggnetwork", repos="http://cran.r-project.org")' >> CRAN.R
RUN echo 'install.packages("R2HTML", repos="http://cran.r-project.org")' >> CRAN.R

RUN Rscript CRAN.R
RUN rm CRAN.R

# Create a new user "developer".
# It will get access to the X11 session in the host computer

ENV uid=1000
ENV gid=${uid}

COPY create_user.sh /

CMD /create_user.sh && sudo -H -u developer /bin/bash
