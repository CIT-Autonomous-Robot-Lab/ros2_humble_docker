FROM ubuntu:22.04

# Timezone, Launguage設定
RUN apt update \
  && apt install -y --no-install-recommends \
     locales \
     software-properties-common tzdata \
  && locale-gen en_US en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && add-apt-repository universe

ENV LANG en_US.UTF-8
ENV TZ=Asia/Tokyo

# Install ROS2
RUN apt update \
  && apt install -y --no-install-recommends \
     curl gnupg2 lsb-release python3-pip vim wget build-essential ca-certificates

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update \
  && apt upgrade \
  && DEBIAN_FRONTEND=noninteractive \
  && apt install -y --no-install-recommends \
     ros-humble-desktop \
  && rm -rf /var/lib/apt/lists/*

RUN bash /opt/ros/humble/setup.sh 

# Install rosdep
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install python3-rosdep
  
# Install colcon
RUN apt-get -y update \
  && apt-get -y upgrade \
  && sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' \
  && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
  && apt -y update \
  && apt -y install python3-colcon-common-extensions
  
# Install turtle-tf2
RUN apt-get -y update \
  && apt-get -y upgrade \
  && sudo apt-get -y install ros-humble-turtle-tf2-py ros-humble-tf2-tools ros-humble-tf-transformations

# Add user and group
ARG UID
ARG GID
ARG USER_NAME
ARG GROUP_NAME

RUN groupadd -g ${GID} ${GROUP_NAME}
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m ${USER_NAME}

USER ${USER_NAME}

WORKDIR /ros2_ws

CMD ["/bin/bash"]

