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
    import org.as3commons.lang.ClassUtils;
    import org.as3commons.reflect.Metadata;
    import org.as3commons.reflect.MetadataArgument;

    public class MetadataUtils
    {

        /**
         * Creates an object from a class and fills it with metadata arguments
         */
        public static function fillObjectFromMetadata( metadatas : Array, metadataName : String, targetClass : Class ) : *
        {
            var instance : * = ClassUtils.newInstance(targetClass);
            for each (var metadata : Metadata in metadatas)
            {
                if (metadata.name == metadataName.toLowerCase())
                {
                    for each (var argument : MetadataArgument in metadata.arguments)
                    {
                        instance[argument.key] = argument.value;
                    }
                }
            }
            return instance;
        }
    }
}
