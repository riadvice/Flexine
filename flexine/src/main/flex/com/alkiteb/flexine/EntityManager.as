/*
   Copyright (C) 2012 Ghazi Triki <ghazi.nocturne@gmail.com>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package com.alkiteb.flexine
{

    import com.alkiteb.flexine.config.SQLConfiguration;
    import com.alkiteb.flexine.entity.Entity;
    import com.alkiteb.flexine.errors.ConfigurationError;
    import com.alkiteb.flexine.metadata.registry.FlexineMetadataRegistry;
    import com.alkiteb.flexine.query.SelectQuery;
    import com.alkiteb.flexine.util.ResultConverter;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    public class EntityManager
    {
        private var _config : SQLConfiguration;

        private static var _instance : EntityManager;

        private static var localInstantiation : Boolean;

        private static var _metadataRegistry : FlexineMetadataRegistry;

        public function EntityManager()
        {
            if (!localInstantiation)
            {
                throw new Error("EntityManager is a singleton. Use EntityManager.instance ");
            }
        }

        public static function get instance() : EntityManager
        {
            if (_instance == null)
            {
                localInstantiation = true;
                _instance = new EntityManager();
                _metadataRegistry = new FlexineMetadataRegistry();
                localInstantiation = false;
            }
            return _instance;
        }

        /**
         * Returns the EntityManager configuration.
         */
        public function set configuration( config : SQLConfiguration ) : void
        {
            // TODO : close the previous connection if exists
            _config = config;
        }

        /**
         * Opens a connection to the database.
         */
        public function openConnection() : void
        {
            // TODO : add async mode
            if (_config)
            {
                _config.connection.open(new File(_config.dbPath), _config.sqlMode);
            }
            else
            {
                throw new ConfigurationError("noConfiguration");
            }
        }

        /**
         * Closes a connection to the database.
         */
        public function closeConnection() : void
        {
            _config.connection.close();
        }

        /**
         * Starts a transaction on the underlying database connection.
         */
        public function beginTransaction() : void
        {
            _config.connection.begin();
        }

        /**
         * Commits a transaction on the underlying database connection.
         */
        public function commit() : void
        {
            _config.connection.commit();
        }

        /**
         * Performs a rollback on the underlying database connection.
         */
        public function rollback() : void
        {
            _config.connection.rollback();
        }

        /**
         * Finds all records of a table using its mapping class.
         */
        public function findAll( clazz : Class ) : ArrayCollection
        {
            var result : ArrayCollection = new ArrayCollection();
            var selectAllQuery : SelectQuery = new SelectQuery(_config, _metadataRegistry.process(clazz));
            selectAllQuery.execute();
            return ResultConverter.convertToCollection(selectAllQuery.result, _metadataRegistry.getEntityByClass(clazz));
        }

    }
}
