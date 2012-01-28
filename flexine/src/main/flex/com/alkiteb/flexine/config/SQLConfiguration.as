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
package com.alkiteb.flexine.config
{
    import flash.data.SQLConnection;

    public class SQLConfiguration
    {
        private var _connection : SQLConnection;
        private var _dbPath : String;
        private var _sqlMode : String;
        private var _persistencePackage : String;

        public function SQLConfiguration( dbPath : String, sqlMode : String )
        {
            // TODO : add isTransactional mode
            _connection = new SQLConnection();
            _dbPath = dbPath;
            _sqlMode = sqlMode;
        }

        /**
         * Returns the inner SQLConnection.
         */
        public function get connection() : SQLConnection
        {
            return _connection;
        }

        public function get dbPath() : String
        {
            return _dbPath;
        }

        /**
         * The full path to the database file.
         */
        public function get sqlMode() : String
        {
            return _sqlMode;
        }

        public function get persistencePackage() : String
        {
            return _persistencePackage;
        }

        /**
         * The persistence package is a package that contains the classes that will be processed
         * for the current connection. It can be set only once and cannot be modified for its parent
         * confiugration.
         */
        public function set persistencePackage( value : String ) : void
        {
            // Persistence package can be set only one time
            if (!_persistencePackage)
            {
                _persistencePackage = value;
            }
        }
    }
}
