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
    import com.alkiteb.flexine.mapping.Table;

    import flash.system.ApplicationDomain;

    import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
    import org.as3commons.reflect.Metadata;
    import org.as3commons.reflect.MetadataArgument;

    public class TableMetadateProcessor extends FlexineMetadataProcessor
    {
        private static const ATTR_NAME : String = "name";

        public var _table : Table;

        public function TableMetadateProcessor( registry : IMetadataProcessorRegistry, applicationDomain : ApplicationDomain = null )
        {
            METADATA_NAME = "Table"
            super(registry, applicationDomain);
        }

        override public function process( target : Object, metadataName : String, params : Array = null ) : *
        {
            var tableMetadata : Metadata = super.process(target, metadataName, params)[0];
            _table = new Table();
            for each (var argument : MetadataArgument in tableMetadata.arguments)
            {
                _table[argument.key] = argument.value;
            }
            // TODO : auto-name table if not set by the user using Inflector
        }

        public function get table() : Table
        {
            return _table;
        }
    }
}
