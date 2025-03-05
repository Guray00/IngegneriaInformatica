#pragma once 

#include <Eigen/Dense>
#include <rclcpp/rclcpp.hpp>
#include <px4_msgs/msg/sensor_gps.hpp>
#include <px4_msgs/srv/vehicle_command.hpp>
#include <px4_msgs/msg/vehicle_local_position.hpp>
#include <px4_msgs/msg/offboard_control_mode.hpp>
#include <px4_msgs/msg/trajectory_setpoint.hpp>

#include "parameters/Parameters.hpp"
#include "obstacle_avoidance/ObstacleAvoidance.hpp"
#include "target_detection/TargetDetection.hpp"
#include "fdds_messages/msg/geo_ping.hpp"
#include "fdds_messages/msg/flocking.hpp"
#include "fdds_messages/msg/pheromone_pause_msg.hpp"
#include "drone/geo.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <stdexcept>
#include <utility>

using namespace std::chrono_literals;

namespace fdds
{
    ...

    class Drone : public rclcpp::Node
    {
    public:

        ...

    private:

        ...

        // Vector to follow for formation
        Eigen::Vector2d formation = Eigen::Vector2d::Zero(); 

        ...

    };
};
