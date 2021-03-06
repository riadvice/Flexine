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
    import com.alkiteb.flexine.mapping.Column;
    import com.alkiteb.flexine.sql.SQL;

    public class CreateTableQuery extends SQLQuery
    {
        private var _ifExists : Boolean = true;

        public function CreateTableQuery( sqlConfiguration : SQLConfiguration, entity : Entity )
        {
            super(sqlConfiguration, entity);
        }

        public function get ifExists() : Boolean
        {
            return _ifExists;
        }

        public function set ifExists( value : Boolean ) : void
        {
            _ifExists = value;
        }

        override public function prepareStatement() : void
        {
            var exists : String = _ifExists ? [SQL.IF, SQL.NOT, SQL.EXISTS].join(' ') : '';
            _statement.text = [SQL.CREATE, SQL.TABLE, exists, tableName, constructColumns()].join(' ');
        }

        private function constructColumns() : String
        {
            // TODO : handle primary keys and foreign keys
            var colDefs : Vector.<String> = new Vector.<String>();
            for each (var column : Column in _entity.columns)
            {
                colDefs.push([column.name, column.type].join(" "));
            }
            if (_entity.getPrimaryKeyNames().length > 0)
            {
                colDefs.push(constructPrimaryKey());
            }
            return ["(", colDefs.join(", "), ")"].join(" ");
        }

        private function constructPrimaryKey() : String
        {
            var primaryKeyQuery : String;
            primaryKeyQuery = [SQL.PRIMARY, SQL.KEY, "(", _entity.getPrimaryKeyNames().join(","), ")"].join(" ");
            return primaryKeyQuery;
        }

    }
}
