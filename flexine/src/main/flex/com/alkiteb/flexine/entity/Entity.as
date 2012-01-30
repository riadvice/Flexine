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
package com.alkiteb.flexine.entity
{
    import com.alkiteb.flexine.mapping.Column;
    import com.alkiteb.flexine.mapping.Table;

    import flash.utils.Dictionary;

    import mx.utils.ArrayUtil;

    import org.as3commons.lang.ArrayUtils;

    public class Entity
    {
        private var _table : Table;
        private var _clazz : Class;
        private var _columnsByName : Dictionary;
        private var _columnsByProperty : Dictionary;
        private var _primaryKey : Dictionary;

        public function Entity()
        {
            _columnsByName = new Dictionary(true);
            _columnsByProperty = new Dictionary(true);
            _primaryKey = new Dictionary(true);
        }

        public function get table() : Table
        {
            return _table;
        }

        public function set table( value : Table ) : void
        {
            _table = value;
        }

        public function get clazz() : Class
        {
            return _clazz;
        }

        public function set clazz( value : Class ) : void
        {
            _clazz = value;
        }

        public function get columns() : Array
        {
            var cols : Array = [];
            for (var key : String in _columnsByName)
            {
                cols.push(_columnsByName[key]);
            }
            return cols;

        }

        public function addColumn( column : Column ) : void
        {
            _columnsByName[column.name] = column;
            _columnsByProperty[column.property] = column;
            if (column.id)
            {
                _primaryKey[column] = column;
            }
        }

        public function getPropertyNameForColumn( columnName : String ) : String
        {
            return _columnsByName[columnName].property;
        }

        public function getColumnForPropertyName( property : String ) : String
        {
            return _columnsByProperty[property].name;
        }

    }
}
