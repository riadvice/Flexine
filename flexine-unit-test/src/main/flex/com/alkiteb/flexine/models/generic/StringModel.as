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
package com.alkiteb.flexine.models.generic
{
    import com.alkiteb.flexine.sql.SQLTypes;

    [Table(name = "string_table")]
    public class StringModel
    {
        [Column]
        public var name : String;

        [Column(name = "last_name")]
        public var lastName : String;

        [Column(name = "xml_data", type = SQLTypes.XML)]
        public var simpleXML : XML;
        
        public var sent_date : Date;

        public var active : Boolean;
    }
}
