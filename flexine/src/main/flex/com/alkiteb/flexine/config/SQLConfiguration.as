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

        public function SQLConfiguration( dbPath : String, sqlMode : String )
        {

            _connection = new SQLConnection();
            _dbPath = dbPath;
            _sqlMode = sqlMode;
        }

        public function get connection() : SQLConnection
        {
            return _connection;
        }

        public function get dbPath() : String
        {
            return _dbPath;
        }

        public function get sqlMode() : String
        {
            return _sqlMode;
        }
    }
}
