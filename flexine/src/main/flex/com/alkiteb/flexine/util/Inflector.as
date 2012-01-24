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
package com.alkiteb.flexine.util
{

    public final class Inflector
    {

        private static var plural : Array = [
            [/$/, 's'],
            [/s$/i, 's'],
            [/(ax|testis$/i, '\1es'],
            [/(octop|virus$/i, '\1i'],
            [/(octop|viri$/i, '\1i'],
            [/(alias|status$/i, '\1es'],
            [/(bus$/i, '\1ses'],
            [/(buffal|tomato$/i, '\1oes'],
            [/([ti]um$/i, '\1a'],
            [/([ti]a$/i, '\1a'],
            [/sis$/i, 'ses'],
            [/(?:([^f]fe|([lr]f$/i, '\1\2ves'],
            [/(hive$/i, '\1s'],
            [/([^aeiouy]|quy$/i, '\1ies'],
            [/(x|ch|ss|sh$/i, '\1es'],
            [/(matr|vert|ind(?:ix|ex$/i, '\1ices'],
            [/(m|louse$/i, '\1ice'],
            [/(m|lice$/i, '\1ice'],
            [/^(ox$/i, '\1en'],
            [/^(oxen$/i, '\1'],
            [/(quiz$/i, '\1zes'],
            ];


        private static var singular : Array = [
            [/s$/i, ''],
            [/(n)ews$/i, '\1ews'],
            [/([ti])a$/i, '\1um'],
            [/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, '\1\2sis'],
            [/(^analy)ses$/i, '\1sis'],
            [/([^f])ves$/i, '\1fe'],
            [/(hive)s$/i, '\1'],
            [/(tive)s$/i, '\1'],
            [/([lr])ves$/i, '\1f'],
            [/([^aeiouy]|qu)ies$/i, '\1y'],
            [/(s)eries$/i, '\1eries'],
            [/(m)ovies$/i, '\1ovie'],
            [/(x|ch|ss|sh)es$/i, '\1'],
            [/(m|l)ice$/i, '\1ouse'],
            [/(bus)es$/i, '\1'],
            [/(o)es$/i, '\1'],
            [/(shoe)s$/i, '\1'],
            [/(cris|ax|test)es$/i, '\1is'],
            [/(octop|vir)i$/i, '\1us'],
            [/(alias|status)es$/i, '\1'],
            [/^(ox)en/i, '\1'],
            [/(vert|ind)ices$/i, '\1ex'],
            [/(matr)ices$/i, '\1ix'],
            [/(quiz)zes$/i, '\1'],
            [/(database)s$/i, '\1']
            ];

        private static var irregular : Array = [
            ["person", "people"],
            ["man", "men"],
            ["child", "children"],
            ["sex", "sexes"],
            ["move", "moves"],
            ["foot", "feet"],
            ["goose", "geese"],
            ["tooth", "teeth"],
            ["cow", "kine"],
            ["zombie", "zombies"]
            ];

        private static var uncountable : Array = [
            "equipment",
            "information",
            "rice",
            "money",
            "species",
            "series",
            "fish",
            "sheep",
            "deer",
            "jeans",
            "means",
            "offspring",
            "moose",
            "bison",
            "salmon",
            "pike",
            "trout",
            "swine",
            "aircraft",
            "scissors",
            "you",
            "pants",
            "shorts",
            "eyeglasses",
            "shrimp",
            "premises",
            "kudos",
            "corps",
            "elk"
            ];

        public static function pluralize( string : String ) : String
        {
            var pattern : RegExp;

            // save some time in the case that singular and plural are the same
            if (uncountable.indexOf(string.toLowerCase()) != -1)
            {
                return string;
            }

            // check for irregular singular forms
            var item : Array;
            for each (item in irregular)
            {
                pattern = new RegExp(item[0] + "$", "i");

                if (pattern.test(string))
                {
                    return string.replace(pattern, item[1]);
                }
            }

            // check for matches using regular expressions
            for each (item in plural)
            {
                if (item[0].test(string))
                {
                    return string.replace(item[0], item[1]);
                }
            }

            return string;
        }

        public static function singularize( string : String ) : String
        {
            var pattern : RegExp;

            // save some time in the case that singular and plural are the same
            if (uncountable.indexOf(string.toLowerCase()) != -1)
            {
                return string;
            }

            // check for irregular singular forms
            var item : Array;
            for each (item in irregular)
            {
                pattern = new RegExp(item[1] + "$", "i");

                if (pattern.test(string))
                {
                    return string.replace(pattern, item[0]);
                }
            }

            // check for matches using regular expressions
            for each (item in singular)
            {
                if (item[0].test(string))
                {
                    return string.replace(item[0], item[1]);
                }
            }

            return string;

        }
    }
}
