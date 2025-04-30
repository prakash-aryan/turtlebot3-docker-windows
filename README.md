# TurtleBot3 Docker Simulation for Windows

This repository contains a Dockerized setup for running TurtleBot3 simulation with SLAM and Navigation capabilities using ROS Noetic on Windows. The setup includes Gazebo simulation, SLAM, and autonomous navigation capabilities.

## Prerequisites

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

## Repository Structure
```
turtlebot3-docker-windows/
├── Dockerfile              # Docker image configuration
├── start.sh                # Container entrypoint script
├── run_turtlebot.ps1       # Windows PowerShell run script
├── maps/                   # Directory for storing maps
└── README.md               # This file
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

### Performance Considerations
- Gazebo is resource-intensive. For better performance:
  - Allocate more CPU/RAM to Docker in Docker Desktop settings
  - Close unnecessary applications while running the simulation