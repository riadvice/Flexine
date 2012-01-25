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
package com.alkiteb.flexine.metadata.process
{
    import com.alkiteb.flexine.mapping.Column;
    import com.alkiteb.flexine.sql.SQLTypes;
    import com.alkiteb.flexine.util.MetadataUtils;

    import org.as3commons.metadata.process.impl.AbstractMetadataProcessor;
    import org.as3commons.reflect.Accessor;
    import org.as3commons.reflect.Type;
    import org.as3commons.reflect.Variable;

    public class ColumnMetadataProcessor extends AbstractMetadataProcessor
    {
        protected var METADATA_NAME : String = "Colmun";

        override public function process( target : Object, metadataName : String, params : Array = null ) : *
        {
            var properties : Array = Type(params[0]).properties;
            var column : Column;
            var columns : Array = [];
            for each (var property : * in properties)
            {
                if ((property is Accessor && property.isWriteable()) || property is Variable)
                {
                    column = MetadataUtils.fillObjectFromMetadata(property.metadata, METADATA_NAME, Column);
                    column.name ||= property.name;
                    column.type ||= SQLTypes.getSQLType(property.type.name);
                    column.property = property.name;
                    columns.push(column);
                }
            }
            return columns;
        }

        public function processColumns( target : Object, params : Array = null ) : Array
        {
            return process(target, METADATA_NAME, params)
        }
    }
}
