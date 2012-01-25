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
    import com.alkiteb.flexine.entity.Entity;
    import com.alkiteb.flexine.sql.SQL;

    public class SelectQuery extends SQLQuery
    {
        private var _distinct : Boolean = false;

        public function SelectQuery( sqlConfiguration : SQLConfiguration, entity : Entity )
        {
            super(sqlConfiguration, entity);
        }

        override public function prepareStatement() : void
        {
            _statement.text = [SQL.SELECT, !_distinct ? SQL.ALL : SQL.DISTINCT, columns, SQL.FROM, tableName ].join(" ") + ";";
        }

        public function get columns() : String
        {
            return "*";
        }

        public function distinct( value : Boolean ) : void
        {
            _distinct = value;
        }
    }
}
