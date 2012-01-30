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
package com.alkiteb.flexine.sql
{

    public class SQLTypes
    {
        public static const BOOLEAN : String = "BOOLEAN";
        public static const DATE : String = "DATE";
        public static const INTEGER : String = "INTEGER";
        public static const NUMBER : String = "REAL";
        public static const OBJECT : String = "OBJECT";
        public static const STRING : String = "TEXT";
        public static const XML : String = "XML";
        public static const XMLLIST : String = "XMLLIST";

        /**
         * Returns the corresponding SQL type to the ActionScript type
         */
        public static function getSQLType( asType : String ) : String
        {
            switch (asType)
            {
                case "int" || "uint":
                    return INTEGER;
                    break;
                case "String":
                    return STRING;
                    break;
                case "Number":
                    return NUMBER;
                    break;
                case "Date":
                    return DATE;
                    break;
                case "Boolean":
                    return BOOLEAN;
                    break;
                case "XML":
                    return XML;
                    break;
                case "XMLList":
                    return XMLLIST;
                    break;
                default:
                    return OBJECT;
            }
        }

    }
}
