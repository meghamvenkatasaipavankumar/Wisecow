FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        netcat-openbsd \
        cowsay \
        fortune-mod \
        fortunes \
    && rm -rf /var/lib/apt/lists/*


# Add /usr/games to PATH so cowsay & fortune are found
ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh .
RUN chmod +x wisecow.sh
EXPOSE 4499
CMD ["./wisecow.sh"]

