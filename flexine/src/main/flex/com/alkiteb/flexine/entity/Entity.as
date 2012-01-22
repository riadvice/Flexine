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
    import com.alkiteb.flexine.mapping.Table;

    public class Entity
    {
        private var _table : Table;
        private var _clazz : Class;

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

    }
}
