FROM openjdk:17-alpine

RUN adduser -D -u 1000 sandbox

WORKDIR /sandbox

USER sandbox

CMD ["java"]
