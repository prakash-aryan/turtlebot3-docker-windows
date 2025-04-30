# Create maps directory if it doesn't exist
if (!(Test-Path "maps")) {
    New-Item -ItemType Directory -Force -Path "maps"
}

# Run container with Xming configuration
docker run -it --rm `
    --privileged `
    -e DISPLAY=host.docker.internal:0 `
    -e LIBGL_ALWAYS_SOFTWARE=1 `
    -e QT_X11_NO_MITSHM=1 `
    -e GAZEBO_GUI_USE_BUILTIN_CAMERA=0 `
    -e ROS_HOSTNAME=localhost `
    -e ROS_MASTER_URI=http://localhost:11311 `
    -v ${PWD}/maps:/root/maps `
    --network host `
    merabro/turtlebot3-sim:latest bash