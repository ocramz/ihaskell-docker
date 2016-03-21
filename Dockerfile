FROM haskell:7.10

MAINTAINER ocramz


# run in the browser
# sudo docker run -p 8778:8778 IHaskell:dev
#
# run this with a terminal
# sudo docker run -rm -i -t IHaskell:dev console

ENV PATH /home/haskell/.cabal/bin:$PATH


RUN apt-get update

RUN apt-get install -y sudo wget curl libtool-bin

RUN sudo apt-get install -yq git pkg-config libtool automake libncurses5-dev python-dev


# # # 

RUN cabal update


# # # ZeroMQ 

RUN curl -L https://github.com/zeromq/zeromq4-x/archive/v4.0.3.tar.gz > v4.0.3.tar.gz && \
    tar xvfz v4.0.3.tar.gz && \
    cd zeromq4-x-4.0.3 && \
    ./autogen.sh && ./configure && \
    make && sudo make install && \
    sudo ldconfig


# # # IHaskell

# # clone & install IHaskell from git repo
# RUN git clone https://github.com/gibiansky/IHaskell && cd IHaskell && ./build.sh all

# # Alternative, install everything directly from hackage without using a repo
RUN cabal install ipython-kernel ihaskell-aeson ihaskell-blaze gtk2hs-buildtools ihaskell-diagrams ihaskell-display ihaskell-magic



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