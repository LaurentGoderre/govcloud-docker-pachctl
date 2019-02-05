FROM golang:alpine as build

MAINTAINER William Hearn, william.hearn@canada.ca

RUN apk add --no-cache --virtual .build-deps \
        git \
        make
RUN go get github.com/laher/goxc \
  && go get -v github.com/pachyderm/pachyderm \
  && cd $GOPATH/src/github.com/pachyderm/pachyderm \
  && make goxc-build

FROM alpine

COPY --from=build /go/src/github.com/pachyderm/pachyderm/build/snapshot/linux_amd64/pachctl /usr/local/bin

CMD pachctl
