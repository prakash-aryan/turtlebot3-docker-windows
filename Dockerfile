FROM osrf/ros:noetic-desktop-full

ENV TURTLEBOT3_MODEL=waffle
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-gazebo \
    ros-noetic-turtlebot3-slam \
    ros-noetic-turtlebot3-navigation \
    ros-noetic-turtlebot3-teleop \
    ros-noetic-rviz \
    ros-noetic-gmapping \
    ros-noetic-slam-gmapping \
    ros-noetic-dwa-local-planner \
    mesa-utils \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]