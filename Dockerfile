FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    python3 \
    python-setuptools \
    python3-pip

# The `pip` packages by Ubuntu is borken in many ways. Install an up to date
# version with easy_install instead.
#RUN python3-pip install

# System dependencies required by cx_Oracle.
RUN apt-get install -y \
    gcc \
    python-dev \
    libaio-dev \
    libaio1

# Binaries downloaded from
# http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html, then
# converted with `alien -d *.rpm`.
WORKDIR /tmp
RUN wget -q https://github.com/brmzkw/cx_oracle/releases/download/oracle-instantclient12.1/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN wget -q https://github.com/brmzkw/cx_oracle/releases/download/oracle-instantclient12.1/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN wget -q https://github.com/brmzkw/cx_oracle/releases/download/oracle-instantclient12.1/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/*.deb
RUN rm -rf /tmp/*.deb

# install cx_oracle
RUN pip3 install cx_Oracle \
    SQLAlchemy \
    pandas \
    fastapi \
    uvicorn

WORKDIR /app
COPY requirements.txt requirements.txt
#RUN pip3 install -r requirements.txt
COPY . .

CMD ['uvicorn', 'main:app', '--host', '0.0.0.0', '--port', '8000']