#pragma once

#include "parameters/yaml.hpp"

namespace fdds
{
    struct Parameters
    {
        int numVehicles;
        int controllerTimerMs;
        float maxSpeed;
        float desiredRelativeAltitude;
        float desiredRelativeDepth;  
        float separationFactor;
        float separationRadius;
        //////////////////////////////////////////////
        float formationFactor;
        float formationTolerance; 
        float coverArea;
        //////////////////////////////////////////////
        float avoidanceRadius;
        float avoidanceFactor;
        float cohesionRadius;
        float cohesionFactor;
        float alignmentRadius;
        float alignmentFactor;
        int radarSideDimension;
        std::string positionsPath;

        // Nuovi parametri per il boundering
        float bounderingavoidanceRadius;
        float bounderingFactor;
        float cellWidth;
        float tangentialFactor;
        float directionFactor;

        explicit Parameters(const int num_vehicles, 
        
                            const int controller_timer_ms,
                            const float max_speed,
                            const float rel_altitude,
                            const float rel_depth, 
                            const float separationFactor, 
                            const float separationRadius,
                            //////////////////////////////////////////////
                            const float formationFactor,
                            const float formationTolerance,  
                            const float coverArea, 
                            //////////////////////////////////////////////
                            const float avoidance_radius,
                            const float avoidance_factor,
                            const float cohesion_radius,
                            const float cohesion_factor,
                            const float alignment_radius,
                            const float alignment_factor,
                            const int radar_side_dimension,
                            const std::string& positions_path,
                            const float bounderingavoidance_radius,   // Nuovo parametro
                            const float boundering_factor,
                            const float cell_width,
                            const float tangentialFactor,
                            const float directionFactor)            // Nuovo parametro
            : numVehicles(num_vehicles),

              controllerTimerMs(controller_timer_ms),
              maxSpeed(max_speed),
              desiredRelativeAltitude(rel_altitude),
              desiredRelativeDepth(rel_depth),  
              separationFactor(separationFactor), 
              separationRadius(separationRadius),
              //////////////////////////////////////////////
              formationFactor(formationFactor),
              formationTolerance(formationTolerance),
              coverArea(coverArea),
              //////////////////////////////////////////////
              avoidanceRadius(avoidance_radius),
              avoidanceFactor(avoidance_factor),
              cohesionRadius(cohesion_radius),
              cohesionFactor(cohesion_factor),
              alignmentRadius(alignment_radius),
              alignmentFactor(alignment_factor),
              radarSideDimension(radar_side_dimension),
              positionsPath(positions_path),
              bounderingavoidanceRadius(bounderingavoidance_radius), // Inizializzazione
              bounderingFactor(boundering_factor),                    // Inizializzazione
              cellWidth(cell_width),
              tangentialFactor(tangentialFactor),
              directionFactor(directionFactor)
        {}

        Parameters() = delete;
    };

    inline Parameters loadOptions(bool verbose) 
    {
        Yaml::Node config_file;
        Yaml::Parse(config_file, "/home/fourdds/.swarm/options.yaml");

        return Parameters(
            config_file["num_vehicles"].As<int>(),

            config_file["controllerTimerMs"].As<int>(), 
            config_file["maxSpeed"].As<float>(), 
            config_file["desiredRelativeAltitude"].As<float>(), 
            config_file["desiredRelativeDepth"].As<float>(), 
            config_file["separationFactor"].As<float>(), 
            config_file["separationRadius"].As<float>(), 
            //////////////////////////////////////////////
            config_file["formationFactor"].As<float>(), 
            config_file["formationTolerance"].As<float>(), 
            config_file["coverArea"].As<float>(), 
            //////////////////////////////////////////////
            config_file["avoidanceRadius"].As<float>(), 
            config_file["avoidanceFactor"].As<float>(), 
            config_file["cohesionRadius"].As<float>(), 
            config_file["cohesionFactor"].As<float>(), 
            config_file["alignmentRadius"].As<float>(), 
            config_file["alignmentFactor"].As<float>(), 
            config_file["radar_side_dimension"].As<int>(), 
            config_file["positions_path"].As<std::string>(), 
            config_file["bounderingavoidanceRadius"].As<float>(), // Caricamento nuovo parametro
            config_file["bounderingFactor"].As<float>(), // Caricamento nuovo parametro
            config_file["cell_width"].As<float>(), 
            config_file["tangentialFactor"].As<float>(), 
            config_file["directionFactor"].As<float>()      
        );
    }
};
