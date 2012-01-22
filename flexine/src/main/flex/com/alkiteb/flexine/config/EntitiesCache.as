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
package com.alkiteb.flexine.config
{
    import com.alkiteb.flexine.entity.Entity;

    import flash.utils.Dictionary;

    import org.as3commons.lang.DictionaryUtils;

    public class EntitiesCache
    {
        private static var _cachedEntities : Dictionary = new Dictionary(true);

        /**
         * Returns true if the class metadata was already scanned.
         */
        public static function isCached( clazz : Class ) : Boolean
        {
            return DictionaryUtils.containsKey(_cachedEntities, clazz);
        }

        /**
         * Caches a scanned entity
         */
        public static function cacheEntity( entity : Entity ) : void
        {
            _cachedEntities[entity.clazz] = entity;
        }

        /**
         * Removes a scanned entity from entities cache.
         */
        public static function deleteEntity( entity : Entity ) : void
        {
            delete _cachedEntities[entity.clazz];
        }
    }
}
