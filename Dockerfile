FROM haskell:7.10

MAINTAINER ocramz

RUN sudo apt-get update
RUN sudo apt-get install -yq git pkg-config libtool automake libncurses5-dev python-dev

RUN curl -L https://github.com/zeromq/zeromq4-x/archive/v4.0.3.tar.gz > v4.0.3.tar.gz && \
    tar xvfz v4.0.3.tar.gz && \
    cd zeromq4-x-4.0.3 && \
    ./autogen.sh && ./configure && \
    make && sudo make install && \
    sudo ldconfig


RUN git clone https://github.com/gibiansky/IHaskell

RUN cd IHaskell && ./build.sh all

# Alternative, install everything directly from hackage without using a repo
# RUN cabal install ipython-kernel ihaskell-aeson ihaskell-blaze gtk2hs-buildtools ihaskell-diagrams ihaskell-display ihaskell-magic

ENV PATH /home/haskell/.cabal/bin:$PATH



# The first time this runs it will install stuff
RUN echo exit | IHaskell console

# Populate with sample notebooks
ADD ./notebooks/ ~/.ihaskell/notebooks/

RUN echo 'c.NotebookApp.ip = "0.0.0.0"' >> ~/.ipython/profile_haskell/ipython_notebook_config.py

# for IHaskell browser
# ENV IHASKELL_NOTEBOOK_EXPOSE 1
EXPOSE 8778

ENTRYPOINT ["IHaskell"]
CMD ["notebook"]