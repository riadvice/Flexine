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
    import com.alkiteb.flexine.entity.Entity;

    import flash.data.SQLResult;

    import mx.collections.ArrayCollection;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.ObjectUtils;

    public class ResultConverter
    {
        public static function convertToTypedObject( result : Object, targetEntity : Entity ) : *
        {
            var typedObject : * = new targetEntity.clazz();
        }

        public static function convertToCollection( result : SQLResult, entity : Entity ) : ArrayCollection
        {
            if (!result)
            {
                return null;
            }

            var collection : ArrayCollection = new ArrayCollection();
            var item : Object;
            for each (var resultItem in result.data)
            {
                item = ClassUtils.newInstance(entity.clazz);
                for each (var prop : * in ObjectUtils.getKeys(resultItem))
                {
                    item[entity.getPropertyNameForColumn(prop)] = resultItem[prop];
                }
                collection.addItem(item);
            }
            return collection;
        }
    }
}
