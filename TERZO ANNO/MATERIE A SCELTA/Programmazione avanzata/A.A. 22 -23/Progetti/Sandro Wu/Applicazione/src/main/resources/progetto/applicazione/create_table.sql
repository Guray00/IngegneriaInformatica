DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL auto_increment,
  `name` varchar(255) DEFAULT NULL UNIQUE,
  `hash` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `id` int NOT NULL auto_increment,
  `token` varchar(255) NOT NULL,
  `user_id` int NOT NULL,
  `expire` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `subscription`;
CREATE TABLE `subscription` (
  `id` int NOT NULL auto_increment,
  `name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `plan`;
CREATE TABLE `plan` (
  `id` int NOT NULL auto_increment,
  `cost` double DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `resource`;
CREATE TABLE `resource` (
  `id` int NOT NULL auto_increment,
  `name` varchar(255) DEFAULT NULL,
  `subscription_id` int DEFAULT NULL,
  `service_id` int DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `plan` varchar(255) DEFAULT NULL,
  -- `cost` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `service`;
CREATE TABLE `service` (
  `id` int NOT NULL auto_increment,
  `category` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `service_plan`;
CREATE TABLE `service_plan` (
  `id` int NOT NULL auto_increment,
  `service_id` int DEFAULT NULL,
  `plan_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `action_log`;
CREATE TABLE `action_log` (
  `id` int NOT NULL auto_increment,
  `time` datetime DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `action` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `cost_log`;
CREATE TABLE `cost_log` (
  `id` int NOT NULL auto_increment,
  `resource_id` int DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `cost` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;