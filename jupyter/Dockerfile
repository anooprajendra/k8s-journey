# Get latest debian release

FROM debian:bookworm

ARG USERNAME=jupyter
ARG USER_UID=1000
ARG USER_GID=$USER_UID


# Install python3, and dependencies
RUN apt update
RUN apt install -y python3 python3-pip python3-venv wget

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH=$VIRTUAL_ENV/bin:$PATH

# Install jupyter, and related tools
RUN pip3 install jupyter pandas pyarrow scikit-learn matplotlib numpy

EXPOSE 8888

RUN useradd -u $USER_UID -U -m $USERNAME
USER $USER_UID
RUN jupyter notebook --generate-config
WORKDIR /notebooks
CMD ["jupyter","notebook","--ServerApp.allow_remote_access=true", "--no-browser", "--ServerApp.ip=0.0.0.0"]
