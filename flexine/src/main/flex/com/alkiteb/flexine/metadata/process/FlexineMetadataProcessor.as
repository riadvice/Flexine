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
    import flash.system.ApplicationDomain;
    
    import org.as3commons.metadata.process.impl.AbstractMetadataProcessor;
    import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
    import org.as3commons.reflect.Type;

    public class FlexineMetadataProcessor extends AbstractMetadataProcessor
    {
        protected var METADATA_NAME : String = null;

        private var _metadataProcessorRegistry : IMetadataProcessorRegistry;
        private var _applicationDomain : ApplicationDomain;

        public function FlexineMetadataProcessor( registry : IMetadataProcessorRegistry, applicationDomain : ApplicationDomain = null )
        {
            super();
            if (METADATA_NAME)
            {
                metadataNames[metadataNames.length] = METADATA_NAME;
            }
            _metadataProcessorRegistry = registry;
            _applicationDomain = applicationDomain ||= Type.currentApplicationDomain;
        }

        override public function process( target : Object, metadataName : String, params : Array = null ) : *
        {
            var type : Type = Type.forInstance(target, _applicationDomain);
            return type.getMetadata(METADATA_NAME);
        }

    }
}
