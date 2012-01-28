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

    import flash.utils.Dictionary;

    public class InsertQuery extends SQLQuery
    {
        private var _obj : Object;

        public function InsertQuery( obj : Object, sqlConfiguration : SQLConfiguration, entity : Entity )
        {
            _obj = obj;
            super(sqlConfiguration, entity);
        }

        override public function prepareStatement() : void
        {
            var colsAndValues : Dictionary = insertableColumnsAndValues();
            _statement.text = [SQL.INSERT, SQL.INTO, tableName, "(", colsAndValues["columns"].join(","), ")",
                SQL.VALUES, "(", colsAndValues["params"].join(","), ")"].join(" ");
        }

        private function insertableColumnsAndValues() : Dictionary
        {
            var dict : Dictionary = new Dictionary(true);
            dict["columns"] = [];
            dict["params"] = [];
            for each (var column : Column in _entity.columns)
            {
                dict["columns"].push(column.name);
                dict["params"].push(":" + column.name);
                _statement.parameters[":" + column.name] = _obj[column.property]
            }
            return dict;
        }
    }
}
