void fdds::BaseStation::geoPingCallback(fdds_messages::msg::GeoPing::ConstSharedPtr msg)
{   
    drone_position_relative << msg->spawn_positions_x, msg->spawn_positions_y;

    Eigen::Vector2d drone_position{msg->latitude_m, msg->longitude_m};
    Eigen::Vector2d drone_speed{msg->speed_north_m_s, msg->speed_east_m_s};
    swarmPositions[msg->vehicle_id - 1] = drone_position;
    swarmSpeeds[msg->vehicle_id - 1] = drone_speed;

    int num_cohesion = 0;
    Eigen::Vector2d cohesion = Eigen::Vector2d::Zero();

    int num_alignment = 0;
    Eigen::Vector2d alignment = Eigen::Vector2d::Zero();

    int num_separation = 0;
    Eigen::Vector2d separation = Eigen::Vector2d::Zero();
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// 1. [DATI PER LA FORMAZIONE e RAGGIUNGIMENTO DELLA DESTINAZIONE]
    /// - Calcolo della Direzione 
    /// - Salvataggio della Posizione del Leader
    /// - Salvataggio della Direzione verso la Destinazione
    if(msg->vehicle_id == 1) 
    { 
        to_one_point(drone_position);
        //zigzag_delta(drone_position);       // Aggiorna "direction" per mantenere la direzione di navigazione o aggiornarla 
        leaderPosition = drone_position;    // Aggiorna "leaderPosition" costantemente per mantenere la Flotta Allineata durante il Movimento  
        
        // Aggiornamento "Posizione di Allineamento" alla Partenza o quando Cambia Direzione 
        double angleDeg = std::acos(direction.dot(alignDirection) / (direction.norm() * alignDirection.norm())) * 180.0 / M_PI;
        if (alignPosition == Eigen::Vector2d::Zero() || angleDeg > 30.0)            // Aggiorna "alignPosition" prima della Partenza per una Destinazione o all'Arrivo di una Destinazione
        {                                                                           // per evitare che ogni volta che il Drone viene spostato dalle forze repulsive cambi il Valore della Posizione di Allinemento,
            alignPosition = drone_position;                                         // altrimenti rende impossibile disporre i Droni in Formazione se aggiornata costantemente 
        }                                                                              
        
        // Aggiornamento "Direzione di Allineamento" alla Partenza o quando Cambia Direzione
        if (alignDirection == Eigen::Vector2d::Zero() || angleDeg > 30.0)           // Aggiorna "alignDirection" per salvarsi la Direzione Calcolata verso la Destinazione UNA VOLTA SOLA 
        {   
            alignDirection = direction; // Nuova direzione di allineamento         
            aligned = false;            // Resetto la condizione di formazione per fermare la flotta per disporsi correttamente   
        }
    }
    
    /// 2. [CALCOLO DEL PARAMETRO 'FORMAZIONE' e DISPOSIZIONE in FORMAZIONE prima della Partenza]
    /// - Calcolo delle Posizioni dei Droni per Disporli lungo l'Asse Perpendicolare alla Direzione calcolata 
    Eigen::Vector2d formationPosition = getFormationPosition(msg->vehicle_id); 
    Eigen::Vector2d formation = (formationPosition - drone_position); 
    
    if (formation.norm() <= options.formationTolerance) // Considera una certa tolleranza da evitare che i Droni  
        formation = Eigen::Vector2d::Zero();            // si correggano eccessivamente da aumentare il tempo di convergenza                                      
    
    /// - Inviati SOLO Parametri "Formazione" (per la Disposizione) e "Separazione" (per evitare che urtino tra loro) finché non sono tutti in Formazione
    if (!aligned) // Una volta allineati alla Partenza, questo algoritmo viene saltato
    {
        if(msg->vehicle_id == 1) aligned = true; // A controllare se lo Sciame sia in Formazione sarà solo il Drone Leader

        for (int i = 0; i < swarmSize; i++)
        {
            const auto& drone_i_position = swarmPositions[i];
            const auto distance = (drone_i_position - drone_position).norm();

            // Controllo per la Separazione
            if (distance < options.separationRadius && i != msg->vehicle_id - 1)
            {
                separation += (options.separationRadius - distance) * (drone_position - drone_i_position).normalized();
                num_separation++;
            }

            // Controllo per la Formazione 
            if (msg->vehicle_id == 1 &&     // Solo il Drone Leader controlla se i Droni NON sono in formazione
                (drone_i_position - getFormationPosition(i + 1)).norm() > options.formationTolerance)   
            {
                aligned = false;
            }
        }    
        
        // Calcolo della Separazione
        if (num_separation != 0)
            separation /= num_separation;
        
        // Se non ancora Allineati...
        if (!aligned) 
        {            
            direction = Eigen::Vector2d::Zero();    // Azzera la Direzione così che i Droni non si spostano verso la Destinazione durante la Disposizione
            
            advertiseFlocking(msg->vehicle_id, cohesion, alignment, separation, formation); // parametri != 0: { Separation, Formation }
                                                                                            // cohesion e alignment lasciati a 0 come alla definizione iniziale
            
            direction = alignDirection;             // Re-impostata la Direzione a quella di Allineamento per evitare 
                                                    // che si aggiorni la Direzione di Allineamento al controllo iniziale
            return; 
        }
    }
    
    /// 3. [CONTROLLO ARRIVO]
    // - Se a questo controllo la Direzione è 0, allora la Flotta è attualmente ARRIVATA a Destinazione
    if (direction == Eigen::Vector2d::Zero()) 
    {
        Eigen::Vector2d null_vector =  Eigen::Vector2d::Zero(); 
        advertiseFlocking(msg->vehicle_id, null_vector, null_vector, null_vector, null_vector); // parametri tutti a 0
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// 4. [FLOCKING DURANTE TRAGITTO]
    // - Solito calcolo dei Parametri di Flocking durante lo spostamento verso la Destinazione

    {
        for (int i = 0; i < swarmSize; i++)
        {
            const auto& drone_i_position = swarmPositions[i];
            const auto& drone_i_speed = swarmSpeeds[i];
            
            const auto distance = (drone_i_position - drone_position).norm();
            if (distance > 0.0001)
            {
                if (distance < options.separationRadius && i != msg->vehicle_id - 1)         
                {
                    separation += (options.separationRadius - distance)*(drone_position - drone_i_position).normalized();    
                    num_separation++;
                }
                else if (distance < options.cohesionRadius)
                {
                    cohesion += drone_i_position;
                    num_cohesion++;
                }
                
                alignment += drone_i_speed;                     
                num_alignment++;
                
            }
        }

        if (num_cohesion != 0) 
        {
            cohesion /= num_cohesion;
            cohesion -= drone_position;
        }

        if (num_alignment != 0)
            alignment /= num_alignment;

        if (num_separation != 0)
            separation /= num_separation;
    }   

    advertiseFlocking(msg->vehicle_id, cohesion, alignment, separation, formation); 
}

Eigen::Vector2d fdds::BaseStation::getFormationPosition(const int droneId) 
{
    // Spaziatura tra i droni proporzionata alla Area di Copertura e Numero di Droni 
    double spacing = options.coverArea / options.numVehicles;
    
    // Limiti dello "spacing" tra Droni 
    if (spacing > options.cohesionRadius - 0.5) // Non può essere più grande del Raggio di Coesione, altrimenti non ha effetto e i droni si potrebbero disperdere
        spacing = options.cohesionRadius - 0.5; 
    
    else if (spacing < options.separationRadius + 0.5) // Non può essere più piccolo del Raggio di Separazione, altrimenti i droni subirebbero costantemente la forza di separazione e non covergerebbero mai 
        spacing = options.separationRadius + 0.5;      // NB: Aggiunto un margine arbitrario per evitare che 
                                                       //     i Droni siano troppo a ridosso di o distanti da l'un l'altro    
    
    // Se il drone è il leader (ID 1), lo posizioniamo al centro in cima
    if (droneId == 1) {
        return aligned ? leaderPosition : alignPosition;        // Se i droni NON sono ancora allineati, 
                                                                // Leader deve "ancorarsi" nella posizione attuale per evitare 
                                                                // di farsi spostare dalle altre forze repulsive calcolate  
                                                                // rispetto ai droni durante la disposizione  
    }
    
    // Determiniamo la posizione lungo l'asse perpendicolare
    int j = floor(droneId / 2);
    int offset = 0; 

    /*  
        Scommentare nel caso si usi la funzione "zigzag"
    
    if (!dirChange) offset = (droneId % 2 != 0) ? -j : +j; // Disposizione simmetrica con "pari" a DX e "dispari" a SX
    else offset = (droneId % 2 == 0) ? -j : +j;            // Cambio tra la posizione dei "pari" e "dispari" per quando cambia direzione 
    
    */

    offset = (droneId % 2 == 0) ? -j : +j;  // Disposizione simmetrica con "pari" a DX e "dispari" a SX

    // Calcolo del vettore perpendicolare alla direzione
    Eigen::Vector2d perpDirection(-alignDirection.y(), alignDirection.x());
    perpDirection.normalize(); // Normalizzazione per evitare scalature non volute

    // Calcolo dell'offset lungo la direzione perpendicolare
    Eigen::Vector2d position = perpDirection * (offset * spacing);

    // Calcolo della posizione finale rispetto al leader
    return leaderPosition + position; 
}

void fdds::BaseStation::advertiseFlocking(const int vehicle_id, 
    const Eigen::Vector2d& cohesion, 
    const Eigen::Vector2d& alignment, 
    const Eigen::Vector2d& separation, 
    const Eigen::Vector2d& formation)
{
fdds_messages::msg::Flocking msg;
msg.cohesion_x = cohesion(0);
msg.cohesion_y = cohesion(1);

msg.alignment_x = alignment(0);
msg.alignment_y = alignment(1);

msg.separation_x = separation(0);
msg.separation_y = separation(1);
////////////////////////////////
msg.formation_x = formation(0);
msg.formation_y = formation(1); 
////////////////////////////////
msg.direction_x = direction(0);
msg.direction_y = direction(1);
flockingPublishers[vehicle_id - 1]->publish(msg);
}