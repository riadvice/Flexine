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

    import flash.filesystem.File;

    public class EntityManager
    {
        private var _config : SQLConfiguration;

        private static var _instance : EntityManager;

        private static var localInstantiation : Boolean;

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
                localInstantiation = false;
            }
            return _instance;
        }

        public function set configuration( config : SQLConfiguration ) : void
        {
            _config = config;
        }

        public function openSyncConnection() : void
        {
            // TODO : add async mode
            // TODO : close the previous connection if exists
            _config.connection.open(new File(_config.dbPath), _config.sqlMode);
        }
    }
}
