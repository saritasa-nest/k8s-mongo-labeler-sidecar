ARG IMAGE_TAG=1.20-bullseye
FROM amd64/golang:${IMAGE_TAG} AS builder
COPY . $GOPATH/src/github.com/combor/k8s-mongo-primary-sidecar/
WORKDIR $GOPATH/src/github.com/combor/k8s-mongo-primary-sidecar/
RUN CGO_ENABLED=0 go build -o /primary-sidecar
FROM scratch
COPY --from=builder /primary-sidecar /primary-sidecar
ENTRYPOINT ["/primary-sidecar"]
