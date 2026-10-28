FROM ubuntu:26.04
WORKDIR /app
COPY build.sh /app/build.sh
RUN chmod a+x /app/build.sh && /app/build.sh
CMD ["/bin/bash"]