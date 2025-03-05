void fdds::Drone::flockingLogic()
{
    // Invio heartbeat e controllo pausa
    heartbeat();

    // Parametri dinamici basati sul tipo di veicolo
    double altitudeParameter = 0.0; // Default per rover
    bool needsTakeoff = false;
    double altitudeThreshold = 0.5;
    if (vehicleType == "iris") {
        altitudeParameter = options.desiredRelativeAltitude;
        needsTakeoff = (-odometryZDownMetres < -altitudeParameter - altitudeThreshold);
        // Stampa del risultato
        ;
    } else if (vehicleType == "uuv_bluerov2_heavy") {
        altitudeParameter = options.desiredRelativeDepth;
        needsTakeoff = (odometryZDownMetres < altitudeParameter - altitudeThreshold);
    }

    // Controllo decollo (solo per veicoli che lo richiedono)
    if (needsTakeoff) {
        requestTakeoff(altitudeParameter);
        sendGeoPing();
        takeoff = false;
        return;
    } else {
        takeoff = true;    
    }

    if (is_paused) {
        sendVelocity(Eigen::Vector2d(0.0, 0.0), altitudeParameter);
        sendGeoPing();
        return;
    }

    // Stampa dei Parametri ricevuti per ciascun Drone 
    /*if (vehicleId != 1) {
        std::cout << "ID: " << vehicleId << " - ";
        std::cout << "direction, cohesion, alignment, avoidance, formation: "
                  << std::setw(11) << direction.x() << ", " << std::setw(11) << direction.y() << " | "
                  << std::setw(11) << cohesion.x()  << ", " << std::setw(11) << cohesion.y()  << " | "
                  << std::setw(11) << alignment.x() << ", " << std::setw(11) << alignment.y() << " | "
                  << std::setw(11) << separation.x() << ", " << std::setw(11) << separation.y() << " | "
                  << std::setw(11) << formation.x() << ", " << std::setw(11) << formation.y()
                  << std::endl;
    }*/

    // Calcolo della velocità
    Eigen::Vector2d velocity = Eigen::Vector2d::Zero();

    Eigen::Rotation2Df rotation_matrix{static_cast<float>(yawRadians)};
    Eigen::Vector2f avoidanceForce{rotation_matrix * obstacleAvoidanceModule.tick()};
    
    // Riduzione di velocity con la forza di avoidance
    Eigen::Vector2d force{avoidanceForce(0), avoidanceForce(1)};   
    velocity -= force * options.avoidanceFactor;

    // Aggiunta della forza di coesione
    velocity += options.cohesionFactor * cohesion;

    // Aggiunta della forza di allineamento
    velocity += options.alignmentFactor * alignment;

    // Aggiunta della forza di separazione
    velocity += options.separationFactor * separation;
    
    // Aggiunta della forza di formazione 
    velocity += options.formationFactor * formation;
    
    // Aggiunta della direzione parameters.directionFactor
    velocity += (direction.normalized() * options.directionFactor);
    
    std::cout << direction.x() << ", " << direction.y() << std::endl; 

    // Aggiunta della forza di boundary handling
    Eigen::Vector2d boundaryForce = handleBoundaries();     
    velocity -= boundaryForce;

    currentSpeed = velocity;

    // Controllo restrizione velocità massima
    double currentNorm = currentSpeed.norm();
    if (currentNorm > options.maxSpeed) 
    {
        double scale = options.maxSpeed / currentNorm;
        currentSpeed *= scale;
    }

    // Invio della velocità e geoping
    sendVelocity(currentSpeed, altitudeParameter);
    sendGeoPing();
}

void fdds::Drone::flockingSubscriptionCallback(fdds_messages::msg::Flocking::ConstSharedPtr msg)
{
    cohesion = Eigen::Vector2d{msg->cohesion_x, msg->cohesion_y};
    alignment = Eigen::Vector2d{msg->alignment_x, msg->alignment_y};
    separation = Eigen::Vector2d{msg->separation_x, msg->separation_y};

    //////////////////////////////////////////////////////////////////
    formation = Eigen::Vector2d{msg->formation_x, msg->formation_y}; 
    //////////////////////////////////////////////////////////////////

    direction = Eigen::Vector2d{msg->direction_x, msg->direction_y};        // ###### Obtain direction from message of the BaseStation

    /*
    std::cout << "Flocking message received:" << std::endl;
    std::cout << "Cohesion: [" << cohesion.x() << ", " << cohesion.y() << "]" << std::endl;
    std::cout << "Alignment: [" << alignment.x() << ", " << alignment.y() << "]" << std::endl;
    std::cout << "Separation: [" << separation.x() << ", " << separation.y() << "]" << std::endl << std::endl;
    std::cout << "Direction: [" << direction.x() << ", " << direction.y() << "]" << std::endl << std::endl;
    */
}