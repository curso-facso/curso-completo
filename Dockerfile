#FROM archlinux:base-devel
FROM rocker/r-ver:4.1.2


RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget \ 
    graphviz \ 
    texlive-latex-extra \ 
    lmodern \ 
    perl && \ 
    /rocker_scripts/install_pandoc.sh && \
    install2.r rmarkdown


### install TinyTex
RUN Rscript -e "install.packages('tinytex')" &&\
    Rscript -e "tinytex::install_tinytex()"

### install bookdown
RUN Rscript -e "install.packages('bookdown')"

ENV RSTUDIO_PANDOC=/usr/lib/rstudio/bin/pandoc


### install LaTeX package 'koma-script'
#RUN Rscript -e "tinytex::tlmgr_install('koma-script')"

### install pandoc
#RUN apt install --yes pandoc pandoc-citeproc pandoc-citeproc-preamble

# Crear un directorio
RUN mkdir -p /home/app
WORKDIR /home/app

# Llevar todo al directorio
COPY . .


# Hacer correr la aplicación
CMD ["R", "-e", "bookdown::render_book('index.Rmd', port = 1234, host = '0.0.0.0')"]
