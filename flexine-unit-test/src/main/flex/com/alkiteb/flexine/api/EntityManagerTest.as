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
package com.alkiteb.flexine.api
{
    import com.alkiteb.flexine.EntityManager;
    import com.alkiteb.flexine.config.SQLConfiguration;

    import flash.data.SQLMode;
    import flash.filesystem.File;

    import flashx.textLayout.operations.RedoOperation;

    import flexunit.framework.Assert;

    public class EntityManagerTest
    {

        private var configCreateMode : SQLConfiguration;
        private var configUpdateMode : SQLConfiguration;
        private var configReadMode : SQLConfiguration;

        private var createDB : String = "api_create_test.db";
        private var readDB : String = "api_update_test.db";
        private var updateDB : String = "api_read_test.db";




        [Before]
        public function setUp() : void
        {
            try
            {
                File.applicationDirectory.resolvePath(createDB).deleteFile();
            }
            catch ( e : Error )
            {
                // The file does not exist, no need to delete it
            }
            configCreateMode = new SQLConfiguration(File.applicationDirectory.resolvePath(createDB).nativePath, SQLMode.CREATE);
            configUpdateMode = new SQLConfiguration(File.applicationDirectory.resolvePath(updateDB).nativePath, SQLMode.UPDATE);
            configReadMode = new SQLConfiguration(File.applicationDirectory.resolvePath(readDB).nativePath, SQLMode.READ);
        }

        [After]
        public function tearDown() : void
        {
        }

        [BeforeClass]
        public static function setUpBeforeClass() : void
        {
        }

        [AfterClass]
        public static function tearDownAfterClass() : void
        {
        }

        [Test]
        /**
         * Instantiates the entity manager.
         */
        public function entityManager() : void
        {
            Assert.assertNotNull(EntityManager.instance);
        }

        [Test]
        /**
         * Opens a database in a create mode.
         */
        public function openInCreateMode() : void
        {
            EntityManager.instance.configuration = configCreateMode;
            var openSuccess : Boolean = false;
            try
            {
                EntityManager.instance.openSyncConnection();
                openSuccess = true;
            }
            catch ( e : Error )
            {
                openSuccess = false;
            }
            Assert.assertTrue(openSuccess);
        }

        [Test]
        /**
         * Tries to open an unexisting databases.
         */
        public function openInUpdateOrReadModeError() : void
        {
            for each (var sqlMode : String in[SQLMode.UPDATE, SQLMode.READ])
            {
                EntityManager.instance.configuration = new SQLConfiguration(File.applicationDirectory.resolvePath("unexisiting_db.db").nativePath, sqlMode);
                var openSuccess : Boolean = false;
                try
                {
                    EntityManager.instance.openSyncConnection();
                    openSuccess = true;
                }
                catch ( e : Error )
                {
                    openSuccess = false;
                }
                Assert.assertFalse(openSuccess);
            }
        }

        [Test]
        /**
         * Tries to open existing databases in read and update modes.
         */
        public function openInUpdateOrReadModeSuccess() : void
        {
            for each (var config : SQLConfiguration in[configUpdateMode, configReadMode])
            {
                EntityManager.instance.configuration = config;
                var openSuccess : Boolean = false;
                try
                {
                    EntityManager.instance.openSyncConnection();
                    openSuccess = true;
                }
                catch ( e : Error )
                {
                    openSuccess = false;
                }
                Assert.assertTrue(openSuccess);
            }
        }

    }
}
