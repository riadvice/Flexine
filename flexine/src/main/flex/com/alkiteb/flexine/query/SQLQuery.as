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
package com.alkiteb.flexine.query
{
    import com.alkiteb.flexine.config.SQLConfiguration;
    
    import flash.data.SQLConnection;
    import flash.data.SQLResult;
    import flash.data.SQLStatement;

    public class SQLQuery
    {
        protected var _statement : SQLStatement;

        protected var _sqlConnection : SQLConnection;

        protected var _table : String;

        public function SQLQuery( sqlConfiguration : SQLConfiguration, table : String )
        {
            _statement = new SQLStatement();
            _statement.sqlConnection = _sqlConnection = sqlConfiguration.connection;
            _table = table;
        }

        public function prepareStatement() : void
        {
        }

        public function execute() : void
        {
            prepareStatement();
            _statement.execute();
        }

        public function get result() : SQLResult
        {
            return _statement.getResult();
        }

        public function toString() : String
        {
            return null
        }

    }
}
