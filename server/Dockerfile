FROM golang:1.15 as build-env
RUN mkdir /code
WORKDIR /code
COPY go.mod .
COPY go.sum .

RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/app ./cmd/server/server.go

FROM alpine:3.13.1
COPY --from=build-env /go/bin/app /go/bin/app
EXPOSE 8080
ENTRYPOINT ["/go/bin/app"]
