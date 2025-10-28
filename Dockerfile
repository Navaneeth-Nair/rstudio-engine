FROM rocker/rstudio:4.4.1

ENV DISABLE_AUTH=true
EXPOSE 8787
CMD ["/init"]