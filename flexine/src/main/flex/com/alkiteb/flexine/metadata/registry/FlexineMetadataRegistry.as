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
    import com.alkiteb.flexine.mapping.Column;
    import com.alkiteb.flexine.mapping.Table;
    import com.alkiteb.flexine.query.CreateTableQuery;
    import com.alkiteb.flexine.sql.SQLTypes;
    import com.alkiteb.flexine.util.MetadataUtils;

    import flash.data.SQLMode;
    import flash.utils.getDefinitionByName;

    import mx.core.FlexGlobals;

    import org.as3commons.bytecode.reflect.ByteCodeType;
    import org.as3commons.reflect.Accessor;
    import org.as3commons.reflect.Type;
    import org.as3commons.reflect.Variable;

    public class FlexineMetadataRegistry
    {
        private static const METADATA_TABLE : String = "Table";
        private static const METADATA_COLUMN : String = "Column";

        private var _entity : Entity;
        private var _processedPackages : Array;

        private var _createTableQuery : CreateTableQuery;
        private var _sqlConfiguration : SQLConfiguration;

        public function FlexineMetadataRegistry()
        {
            super();
            _processedPackages = [];
        }

        /**
         * Processes the package that the user defines. This package must contain
         * user persistence classes.
         */
        public function processPackage( sqlConfiguration : SQLConfiguration = null ) : void
        {
            var startDate : Date = new Date();
            _sqlConfiguration = sqlConfiguration
            var packageName : String = sqlConfiguration.persistencePackage;
            if (packageName && _processedPackages.indexOf(packageName) < 0)
            {
                var loadedClasses : Object = ByteCodeType.metaDataLookupFromLoader(FlexGlobals.topLevelApplication.systemManager.loaderInfo);
                for each (var className : String in loadedClasses[METADATA_TABLE.toLowerCase()])
                {
                    processClass(getDefinitionByName(className) as Class);
                }
                _processedPackages.push(packageName);
            }

        }

        /**
         * Processes a class metadata to extract the Entity
         */
        public function processClass( target : Object, params : Array = null ) : Entity
        {
            // First we try to find if the class entity was already cached
            _entity = getEntityByClass(target as Class);
            if (!_entity)
            {
                // Else we scan the class metadata
                var type : Type = Type.forInstance(target);

                _entity = new Entity();
                _entity.clazz = target as Class;
                _entity.table = processTable(type);
                processColumns(type);

                // Creating the table if not exists
                if (_sqlConfiguration && _sqlConfiguration.sqlMode != SQLMode.READ)
                {
                    _createTableQuery = new CreateTableQuery(_sqlConfiguration, _entity);
                    _createTableQuery.execute();
                }

                EntitiesCache.cacheEntity(_entity);
            }
            return _entity;
        }

        /**
         * Processes Table metadata
         */
        private function processTable( type : Type ) : Table
        {
            var table : Table = new Table();
            var tableMetadatas : Array = type.metadata;
            table = MetadataUtils.fillObjectFromMetadata(tableMetadatas, METADATA_TABLE, Table);
            table.schema ||= "main";
            table.name ||= type.name;
            return table;
        }

        private function processColumns( type : Type ) : void
        {
            var properties : Array = type.properties;
            var column : Column;
            for each (var property : * in properties)
            {
                if ((property is Accessor && property.isWriteable()) || property is Variable)
                {
                    column = MetadataUtils.fillObjectFromMetadata(property.metadata, METADATA_COLUMN, Column);
                    column.name ||= property.name;
                    column.type ||= SQLTypes.getSQLType(property.type.name);
                    column.property = property.name;
                    _entity.addColumn(column);
                }
            }
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
