FROM golang:latest AS rmapi

# ENV GOPATH /go
# ENV PATH ${GOPATH}/bin:/usr/local/go/bin:$PATH
ARG RMAPIREPO=github.com/ddvk/rmapi
# as per https://github.com/juruen/rmapi/blob/18a9fb803f6afef2067d9491fddcb0f03cba2ee0/Dockerfile#L8
ARG CGO_ENABLED=0

WORKDIR /src/
RUN git clone --depth=1 https://${RMAPIREPO} && cd rmapi && go install

FROM python:bookworm

# rmapi
COPY --from=rmapi /go/bin/rmapi /usr/bin/rmapi
RUN chmod +x /usr/bin/rmapi

# needed to install openjdk-11-jre-headless
RUN mkdir -p /usr/share/man/man1

# imagemagick, pdftk, ghostscript, pdfcrop, weasyprint
RUN apt-get update -q \
    && apt-get install --no-install-recommends -y -q \
        libmagickwand-dev \
        pdftk \
        ghostscript \
	      poppler-utils \
        nodejs npm

RUN pip install lxml[html_clean]
RUN pip install --no-cache-dir 'git+https://github.com/alan-turing-institute/ReadabiliPy'
RUN pip install --no-cache-dir paper2remarkable

RUN readabilipy --help
RUN p2r --help

ENTRYPOINT ["p2r"]
