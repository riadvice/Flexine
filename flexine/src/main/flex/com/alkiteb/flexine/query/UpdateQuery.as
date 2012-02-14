/*
   Copyright (C) 2011 Ghazi Triki <ghazi.nocturne@gmail.com>

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

    public class UpdateQuery extends SQLQuery
    {
        private var _obj : Object;

        public function UpdateQuery( obj : Object, sqlConfiguration : SQLConfiguration, entity : Entity )
        {
            _obj = obj;
            super(sqlConfiguration, entity);
        }

        override public function prepareStatement() : void
        {
            var conditions : Array = updateCondition();
            _statement.text = [SQL.UPDATE, tableName, SQL.SET, parametersSetSubQuery(), SQL.WHERE, conditions.join(" " + SQL.AND + " ")].join(" ");
        }

        private function parametersSetSubQuery() : String
        {
            var params : Array = [];
            for each (var column : Column in _entity.columns)
            {
                params.push(column.name + "=" + ":" + column.name)
                _statement.parameters[":" + column.name] = _obj[column.property]
            }
            return params.join(", ");
        }

        private function updateCondition() : Array
        {
            var params : Array = [];
            var where : String;
            var keys : Vector.<String> = _entity.getPrimaryKeyNames();
            if (keys.length > 0)
            {
                for each (var key : String in keys)
                {
                    params.push(key + "=:" + key);
                    _statement.parameters[":" + key] = _obj[key]
                }
            }
            else if (keys.length < 1)
            {
                for each (var column : Column in _entity.columns)
                {
                    params.push(column.name + "=:" + column.name);
                    _statement.parameters[":" + column.name] = _obj[column.property]
                }
            }
            return params;
        }
    }
}
