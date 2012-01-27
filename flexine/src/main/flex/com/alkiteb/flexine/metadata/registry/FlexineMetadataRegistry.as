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
    import com.alkiteb.flexine.config.EntitiesCache;
    import com.alkiteb.flexine.config.SQLConfiguration;
    import com.alkiteb.flexine.entity.Entity;
    import com.alkiteb.flexine.metadata.process.ColumnMetadataProcessor;
    import com.alkiteb.flexine.metadata.process.TableMetadateProcessor;
    import com.alkiteb.flexine.query.CreateTableQuery;

    import flash.data.SQLMode;

    import org.as3commons.metadata.registry.impl.AS3ReflectMetadataProcessorRegistry;
    import org.as3commons.reflect.Type;

    public class FlexineMetadataRegistry extends AS3ReflectMetadataProcessorRegistry
    {
        private var _entity : Entity;
        private var _tableMetadataProcessor : TableMetadateProcessor;
        private var _columnMetadataProcessor : ColumnMetadataProcessor;

        private var _createTableQuery : CreateTableQuery;

        public function FlexineMetadataRegistry()
        {
            super();
            addProcessor(_tableMetadataProcessor = new TableMetadateProcessor(this));
            _columnMetadataProcessor = new ColumnMetadataProcessor();
        }

        override public function process( target : Object, params : Array = null ) : *
        {
            // First we try to find if the class entity was already cached
            _entity = getEntityByClass(target as Class);
            if (!_entity)
            {
                // Else we scan the class metadata
                super.process(target, params);
                var type : Type = Type.forInstance(target, super.applicationDomain);

                _entity = new Entity();
                _entity.clazz = target as Class;
                _entity.table = _tableMetadataProcessor.table;
                _entity.columns = _columnMetadataProcessor.processColumns(target, [type]);

                // Creating the table if not exists
                if (params && params[0] is SQLConfiguration && params[0].sqlMode != SQLMode.READ)
                {
                    _createTableQuery = new CreateTableQuery(params[0], _entity);
                    _createTableQuery.execute();
                }

                EntitiesCache.cacheEntity(_entity);
            }
            return _entity;
        }

        /**
         * Returns the entity of class.
         */
        public function getEntityByClass( clazz : Class ) : Entity
        {
            return EntitiesCache.getEntity(clazz);
        }

    }
}
