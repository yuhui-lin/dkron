FROM golang:1.10
MAINTAINER Victor Castell <victor@victorcastell.com>

EXPOSE 8080 8946

RUN wget https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -O /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep && \
    apt-get update && apt-get install -y redis-tools

WORKDIR /gopath/src/github.com/victorcoder/dkron

ENV GOPATH /gopath
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

#COPY Gopkg.* ./

COPY . ./
RUN dep ensure
RUN go build *.go

RUN GOBIN=`pwd` go clean -i ./builtin/... && \
    GOBIN=`pwd` go clean && \
    GOBIN=`pwd` go install ./builtin/... && \
    go build -o main

CMD ["/gopath/src/github.com/victorcoder/dkron/main"]

