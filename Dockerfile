FROM ubuntu:focal AS xprabx

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install tzdata -y
ENV TZ=America/New_York
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata


# begin general stuff
RUN apt update && \
    apt install lsb-release -y && \
    apt install vim -y && \
    apt install wget -y && \
    apt install gnupg1 -y 
# end general stuff 

#begin xpra
RUN apt update && apt install ca-certificates -y 
RUN wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc
RUN cd "/etc/apt/sources.list.d/" && \
    wget https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/focal/xpra.sources
RUN apt update && apt install xpra -y
ENV XPRA_DISPLAY=":100"
ARG XPRA_PORT=10000
ENV XPRA_PORT=$XPRA_PORT
EXPOSE $XPRA_PORT
COPY run_in_xpra /usr/bin/run_in_xpra
# end xpra

RUN apt install xterm -y
