FROM gcc:13-bookworm

RUN useradd -m -u 1000 sandbox

WORKDIR /sandbox

USER sandbox

CMD ["bash"]
