# TurtleBot3 Docker Simulation for Windows

This repository contains a Dockerized setup for running TurtleBot3 simulation with SLAM and Navigation capabilities using ROS Noetic on Windows. The setup includes Gazebo simulation, SLAM, and autonomous navigation capabilities.


https://github.com/user-attachments/assets/08ef5b0b-3a20-4acf-a601-7cb4489eec45

## What is Docker?

Docker is an open-source platform that automates the deployment, scaling, and management of applications by using containerization. Unlike traditional virtual machines, Docker containers share the host system's OS kernel, making them more lightweight and efficient.

![Docker in a Data Center](https://github.com/user-attachments/assets/c6657892-4e18-41d3-8742-f483ce433645)
*Image credit: https://www.iteachrecruiters.com/blog/docker-explained-visually-for-non-technical-folks/*

### How Docker Works

As illustrated in the image above, Docker provides several key advantages in a data center environment:

1. **Containerization**: Docker packages applications and their dependencies into isolated containers, eliminating the "it works on my machine" problem
2. **Resource Efficiency**: Containers share the OS kernel and use fewer resources than traditional VMs
3. **Isolation**: Each container runs in isolation, preventing conflicts between applications
4. **Portability**: Containers run consistently across different environments (development, testing, production)

### Docker Architecture

Docker uses a client-server architecture with these main components:

- **Docker Daemon**: The background service running on the host that manages building, running, and distributing Docker containers
- **Docker Client**: The primary way to interact with Docker through the command line
- **Docker Images**: Read-only templates with instructions for creating containers
- **Docker Containers**: Runnable instances of Docker images
- **Docker Registry**: Repository for storing and sharing Docker images (like Docker Hub)

### Common Docker Commands

Here are some essential Docker commands:

```bash
# Display Docker version information
docker --version

# Download an image from Docker Hub
docker pull [image_name]:[tag]

# List all downloaded images
docker images

# Run a container from an image
docker run [options] [image_name]

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a running container
docker stop [container_id]

# Remove a container
docker rm [container_id]

# Remove an image
docker rmi [image_id]

# Build an image from a Dockerfile
docker build -t [name]:[tag] [path_to_dockerfile]

# Execute a command in a running container
docker exec -it [container_id] [command]

# View container logs
docker logs [container_id]

# Create a network for container communication
docker network create [network_name]
```

### Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. Key commands:

```bash
# Start services defined in docker-compose.yml
docker-compose up

# Run services in the background
docker-compose up -d

# Stop services
docker-compose down

# View service logs
docker-compose logs
```

## Prerequisites

0. Install [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. Install [Xming X Server](https://sourceforge.net/projects/xming/) - This is required for displaying GUI applications from Docker

## Getting Started

1. Clone this repository:
```powershell
git clone https://github.com/prakash-aryan/turtlebot3-docker-windows.git
cd turtlebot3-docker-windows
```

2. Pull the Docker image from Docker Hub:
```powershell
docker pull merabro/turtlebot3-sim:latest
```

## Setting Up Xming

1. Start Xming:
   - Run Xming from the Start menu
   - It will appear in your system tray (near clock)
  
     ![image](https://github.com/user-attachments/assets/68946471-4e51-4f82-83f9-f7ab51d9eaab)

## Running the Simulation

Open three PowerShell windows in the repository directory:

### Terminal 1 (Gazebo)
```powershell
.\run_turtlebot.ps1
```
Once inside the container:
```bash
roslaunch turtlebot3_gazebo turtlebot3_world.launch
```

### Terminal 2 (SLAM)
```powershell
.\run_turtlebot.ps1
```
Once inside the container:
```bash
roslaunch turtlebot3_slam turtlebot3_slam.launch slam_methods:=gmapping
```

### Terminal 3 (Teleop)
```powershell
.\run_turtlebot.ps1
```
Once inside the container:
```bash
roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch
```

## Creating and Saving the Map

1. Use teleop to drive the robot around and create the map:
   - w: Move forward
   - x: Move backward
   - a: Turn left
   - d: Turn right
   - s: Stop
   - Space: Emergency stop
   - q: Quit

2. When satisfied with the map, in the teleop terminal:
```bash
# Stop teleop with Ctrl+C, then:
rosrun map_server map_saver -f /root/maps/my_map
```

## Running Navigation

After creating and saving a map, start navigation in a new terminal:
```powershell
.\run_turtlebot.ps1
```
Once inside the container:
```bash
roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=/root/maps/my_map.yaml
```

Use the "2D Nav Goal" button in RViz to set navigation goals for the robot:
1. Click on the "2D Nav Goal" button in the RViz toolbar
2. Click and drag on the map to set the goal position and orientation
3. The robot will plan a path and navigate to the goal

## Docker Benefits in this Project

This TurtleBot3 Docker setup demonstrates several key advantages of containerization:

1. **Environment Consistency**: All dependencies, ROS packages, and configurations are bundled together
2. **Cross-Platform Compatibility**: Works seamlessly on Windows via WSL2
3. **Isolation**: The ROS environment doesn't interfere with your host system
4. **Ease of Distribution**: Anyone can run the same setup with a simple `docker pull` command
5. **Resource Efficiency**: Lighter than running a full virtual machine
6. **GUI Application Support**: Runs graphical applications (Gazebo, RViz) through X11 forwarding

## Repository Structure

```
turtlebot3-docker-windows/
├── Dockerfile              # Docker image configuration
├── start.sh                # Container entrypoint script
├── run_turtlebot.ps1       # Windows PowerShell run script
├── maps/                   # Directory for storing maps
└── README.md               # This file
```

## Dockerfile Details

Our Dockerfile is built on top of a ROS Noetic base image and includes:

```dockerfile
FROM osrf/ros:noetic-desktop-full

# Install dependencies
RUN apt-get update && apt-get install -y \
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-simulations \
    ros-noetic-slam-gmapping \
    ros-noetic-navigation \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV TURTLEBOT3_MODEL=burger
ENV ROS_MASTER_URI=http://localhost:11311
ENV ROS_HOSTNAME=localhost

# Set up workspace
WORKDIR /root

# Copy entrypoint script
COPY start.sh /
RUN chmod +x /start.sh

# Create maps directory
RUN mkdir -p /root/maps

ENTRYPOINT ["/start.sh"]
```

## Troubleshooting

### Display Issues
- If Gazebo fails to launch or crashes:
  - Verify Xming is running with the `-ac` flag
  - Restart Xming and try again
  - Make sure your firewall isn't blocking Xming

### ROS Communication Issues
- If ROS nodes can't communicate:
  - Verify all containers are using the same network settings
  - Check Docker Desktop network access
  - Make sure all terminals are using the same ROS_MASTER_URI

### Docker-Specific Issues
- If you encounter "permission denied" errors:
  - On Windows, ensure Docker Desktop has proper access to the shared folders
  - On Linux, you might need to run Docker with sudo or add your user to the docker group
- If container exits immediately:
  - Use `docker run` with the `-it` flag to keep the container running
  - Check the logs with `docker logs [container_id]` to identify issues

### Performance Considerations
- Gazebo is resource-intensive. For better performance:
  - Allocate more CPU/RAM to Docker in Docker Desktop settings
  - Close unnecessary applications while running the simulation
  - Consider using a Linux host for better performance with Docker

## Further Docker Learning Resources

- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/) - Public repository of Docker images
- [Docker Curriculum](https://docker-curriculum.com/) - Comprehensive Docker tutorial
- [Play with Docker](https://labs.play-with-docker.com/) - Interactive Docker playground
