/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `copies` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `holder_id` bigint(20) DEFAULT NULL,
  `item_id` bigint(20) DEFAULT NULL,
  `version_id` bigint(20) DEFAULT NULL,
  `location_id` bigint(20) DEFAULT NULL,
  `condition` enum('unknown','new','excellent','good','fair','poor') NOT NULL DEFAULT 'unknown',
  `is_playable` tinyint(1) DEFAULT 0,
  `is_borrowable` tinyint(1) DEFAULT 0,
  `is_tradeable` tinyint(1) DEFAULT 0,
  `is_purchaseable` tinyint(1) DEFAULT 0,
  `asking_price_cents` int(11) DEFAULT NULL,
  `asking_currency` varchar(3) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_copies_on_public_id` (`public_id`),
  KEY `index_copies_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_copies_on_updated_at` (`updated_at`),
  KEY `index_copies_on_item_id` (`item_id`),
  KEY `index_copies_on_location_id` (`location_id`),
  KEY `index_copies_on_holder_id` (`holder_id`),
  KEY `index_copies_on_version_id` (`version_id`),
  CONSTRAINT `fk_rails_279e87b1be` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `fk_rails_4986047638` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `fk_rails_58e9582363` FOREIGN KEY (`version_id`) REFERENCES `versions` (`id`),
  CONSTRAINT `fk_rails_9aec6a3f53` FOREIGN KEY (`holder_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `expansions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `expansions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_expansions_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_expansions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_games_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_games_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `identities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `token` text DEFAULT NULL,
  `secret` text DEFAULT NULL,
  `refresh_token` text DEFAULT NULL,
  `token_expires_at` datetime(6) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_identities_on_uid_and_provider` (`uid`,`provider`),
  KEY `index_identities_on_provider` (`provider`),
  KEY `index_identities_on_email` (`email`),
  KEY `index_identities_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_5373344100` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `item_expansions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_expansions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) DEFAULT NULL,
  `expansion_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_item_expansions_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_item_expansions_on_updated_at` (`updated_at`),
  KEY `index_item_expansions_on_expansion_id` (`expansion_id`),
  KEY `index_item_expansions_on_item_id` (`item_id`),
  CONSTRAINT `fk_rails_023d597e7b` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `fk_rails_9ffaf8bc8a` FOREIGN KEY (`expansion_id`) REFERENCES `expansions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `playable_id` bigint(20) DEFAULT NULL,
  `playable_type` varchar(255) DEFAULT NULL,
  `bgg_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `bgg_image_url` varchar(255) DEFAULT NULL,
  `bgg_thumbnail_url` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_items_on_bgg_id` (`bgg_id`),
  UNIQUE KEY `index_items_on_public_id` (`public_id`),
  UNIQUE KEY `index_items_on_playable_type_and_playable_id` (`playable_type`,`playable_id`),
  KEY `index_items_on_name` (`name`),
  KEY `index_items_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_items_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `google_place_id` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_locations_on_public_id` (`public_id`),
  KEY `index_locations_on_google_place_id` (`google_place_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `oauth_access_grants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth_access_grants` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resource_owner_id` bigint(20) DEFAULT NULL,
  `application_id` bigint(20) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `expires_in` int(11) NOT NULL,
  `redirect_uri` text NOT NULL,
  `scopes` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime(6) NOT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_access_grants_on_token` (`token`),
  KEY `index_oauth_access_grants_on_application_id` (`application_id`),
  KEY `index_oauth_access_grants_on_resource_owner_id` (`resource_owner_id`),
  CONSTRAINT `fk_rails_330c32d8d9` FOREIGN KEY (`resource_owner_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_b4b53e07b8` FOREIGN KEY (`application_id`) REFERENCES `oauth_applications` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `oauth_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth_access_tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resource_owner_id` bigint(20) DEFAULT NULL,
  `application_id` bigint(20) DEFAULT NULL,
  `token` text NOT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  `expires_in` int(11) DEFAULT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  `previous_refresh_token` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_access_tokens_on_refresh_token` (`refresh_token`),
  UNIQUE KEY `index_oauth_access_tokens_on_token` (`token`) USING HASH,
  KEY `index_oauth_access_tokens_on_application_id` (`application_id`),
  KEY `index_oauth_access_tokens_on_resource_owner_id` (`resource_owner_id`),
  CONSTRAINT `fk_rails_732cb83ab7` FOREIGN KEY (`application_id`) REFERENCES `oauth_applications` (`id`),
  CONSTRAINT `fk_rails_ee63f25419` FOREIGN KEY (`resource_owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `oauth_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth_applications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `redirect_uri` text DEFAULT NULL,
  `scopes` varchar(255) NOT NULL DEFAULT '',
  `confidential` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauth_applications_on_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ownerships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ownerships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `owner_id` bigint(20) DEFAULT NULL,
  `copy_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `discarded_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ownerships_on_public_id` (`public_id`),
  UNIQUE KEY `index_ownerships_on_owner_id_and_copy_id` (`owner_id`,`copy_id`),
  KEY `index_ownerships_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_ownerships_on_updated_at` (`updated_at`),
  KEY `index_ownerships_on_discarded_at` (`discarded_at`),
  KEY `index_ownerships_on_copy_id` (`copy_id`),
  KEY `index_ownerships_on_owner_id` (`owner_id`),
  CONSTRAINT `fk_rails_00c2733aa0` FOREIGN KEY (`copy_id`) REFERENCES `copies` (`id`),
  CONSTRAINT `fk_rails_fbd594700f` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_locations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `location_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `discarded_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_locations_on_public_id` (`public_id`),
  UNIQUE KEY `index_user_locations_on_user_id_and_location_id` (`user_id`,`location_id`),
  KEY `index_user_locations_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_user_locations_on_updated_at` (`updated_at`),
  KEY `index_user_locations_on_discarded_at` (`discarded_at`),
  KEY `index_user_locations_on_location_id` (`location_id`),
  KEY `index_user_locations_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_374794d0e3` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `fk_rails_3aef0f4606` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `bgg_username` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `encrypted_password` varchar(255) DEFAULT NULL,
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime(6) DEFAULT NULL,
  `remember_created_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_username` (`username`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_public_id` (`public_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `versions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(255) DEFAULT NULL,
  `item_id` bigint(20) DEFAULT NULL,
  `bgg_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `publication_year` smallint(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_versions_on_bgg_id` (`bgg_id`),
  UNIQUE KEY `index_versions_on_public_id` (`public_id`),
  KEY `index_versions_on_name` (`name`),
  KEY `index_versions_on_created_at_and_updated_at` (`created_at`,`updated_at`),
  KEY `index_versions_on_updated_at` (`updated_at`),
  KEY `index_versions_on_item_id` (`item_id`),
  CONSTRAINT `fk_rails_ab163ad627` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20251105000611'),
('20251019190136'),
('20251019185806'),
('20251019184703'),
('20251018010740'),
('20251018001048'),
('20250930233540'),
('20250930233447'),
('20250930230233'),
('20250805204007'),
('20240510042001'),
('20240507095138'),
('20240507031318'),
('20240506234857'),
('20240429075252'),
('20240429042105'),
('20240429040015'),
('20240427063840'),
('20240427053253'),
('20240425001259'),
('20240424232850'),
('20240424190721'),
('20240424031040'),
('20240327234908'),
('20240327212325');

