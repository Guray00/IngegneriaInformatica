#pragma once

#include <rclcpp/rclcpp.hpp>
#include <vector>
#include <Eigen/Dense>

#include "fdds_messages/msg/geo_ping.hpp"
#include "fdds_messages/msg/flocking.hpp"
#include "fdds_messages/msg/pheromone_msg.hpp"
#include "parameters/Parameters.hpp"
#include "rclcpp/clock.hpp"
#include "rosgraph_msgs/msg/clock.hpp"
#include <mutex>

#include <fstream>
#include <filesystem>
#include <string>
#include <sstream>
#include <chrono>

namespace fdds
{
    class BaseStation : public rclcpp::Node
    {
    public:
        
        ...

    private:

        ...    

        // Posizione del Drone Leader (ID = 1)
        Eigen::Vector2d leaderPosition = Eigen::Vector2d::Zero();           // Coordinate di Posizione usate come punto di Riferimento per il Calcolo delle Posizione della Formazione della Flotta 
        Eigen::Vector2d alignPosition = Eigen::Vector2d::Zero();            // Coordinate del Drone Leader per "ancoralo" in questa Posizione per l'Allineamento dei Droni PRIMA di Direzionarsi verso la Destinazione
        Eigen::Vector2d alignDirection = Eigen::Vector2d::Zero();           // Direzione lungo la quale Allineare i Droni PRIMA della Partenza

        // Tiene conto di quando i Droni si sono allineati alla Partenza o quando Cambia di Direzione
        bool aligned = false;   
        //bool dirChange = false;     // scommentare quando usare "zigzag"  

        ...

        /// @brief Gestisce il Posizionamento dei Droni per Disporli in forma Piramidale come uno stormo di Uccelli, coprendo solo il perimetro // (***) 
        Eigen::Vector2d getFormationPosition(const int id); // (***) Nuova Funzione per gestire la Copertura della Flotta 

        /// @brief Utility function to send FlockCenterOfMass messages.
        void advertiseFlocking(const int vehicle_id, const Eigen::Vector2d& cohesion, const Eigen::Vector2d& alignment, const Eigen::Vector2d& separation, const Eigen::Vector2d& formation);
    };
};