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
package com.alkiteb.flexine.metadata.registry
{
    import com.alkiteb.flexine.entity.Entity;
    import com.alkiteb.flexine.metadata.process.TableMetadateProcessor;
    
    import org.as3commons.metadata.registry.impl.AS3ReflectMetadataProcessorRegistry;

    public class FlexineMetadataRegistry extends AS3ReflectMetadataProcessorRegistry
    {
        private var _entity : Entity;
        private var _tableMetadateProcessor : TableMetadateProcessor;

        public function FlexineMetadataRegistry()
        {
            super();
            addProcessor(_tableMetadateProcessor = new TableMetadateProcessor(this));
        }

        override public function process( target : Object, params : Array = null ) : *
        {
            _entity = new Entity();
            super.process(target, params);
            _entity.clazz = target as Class;
            _entity.table = _tableMetadateProcessor.table;
            return _entity;
        }

    }
}
