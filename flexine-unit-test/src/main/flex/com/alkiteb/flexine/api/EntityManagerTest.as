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
    import com.alkiteb.flexine.errors.ConfigurationError;
    import com.alkiteb.flexine.models.generic.StringModel;

    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.data.SQLStatement;
    import flash.filesystem.File;
    import flash.net.registerClassAlias;

    import flexunit.framework.Assert;

    import mx.collections.ArrayCollection;

    public class EntityManagerTest
    {

        private var configCreateMode : SQLConfiguration;
        private var configUpdateMode : SQLConfiguration;
        private var configReadMode : SQLConfiguration;

        private var configGenericDb : SQLConfiguration;

        private var createDB : String = "api_create_test.db";
        private var updateDB : String = "api_update_test.db";
        private var readDB : String = "api_read_test.db";

        private var genericDB : String = "generic_db_test.db";

        [Before]
        public function setUp() : void
        {
            registerClasses();
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

            configGenericDb = new SQLConfiguration(File.applicationDirectory.resolvePath(genericDB).nativePath, SQLMode.CREATE)
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

        /**
         * Cleans up the configuration before each test run
         */
        public function cleanUp() : void
        {
            try
            {
                EntityManager.instance.closeConnection();
            }
            catch ( e : Error )
            {
                // No connection was open
            }
            EntityManager.instance.configuration = null;
        }

        public function registerClasses() : void
        {
            StringModel;
        }

        public function prepareSimpleTable( connection : SQLConnection ) : void
        {
            for each (var query : String in["DROP TABLE IF EXISTS main.string_table",
                "CREATE TABLE IF NOT EXISTS main.string_table (name TEXT)",
                "INSERT INTO main.string_table values('hello')",
                "INSERT INTO main.string_table values('world');"])
            {
                var stmt : SQLStatement = new SQLStatement();
                stmt.sqlConnection = connection;
                stmt.sqlConnection.begin();
                stmt.text = query;
                stmt.execute();
                stmt.sqlConnection.commit();
            }

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
                EntityManager.instance.openConnection();
                openSuccess = true;
            }
            catch ( e : Error )
            {
                Assert.assertTrue(openSuccess);
            }
            cleanUp();
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
                    EntityManager.instance.openConnection();
                    openSuccess = true;
                }
                catch ( e : Error )
                {
                    Assert.assertFalse(openSuccess);
                }
                cleanUp();
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
                    EntityManager.instance.openConnection();
                    openSuccess = true;
                }
                catch ( e : Error )
                {
                    Assert.assertTrue(openSuccess);
                }
                cleanUp();
            }
        }

        [Test]
        /**
         * Tries to open existing databases in read and update modes.
         */
        public function openWithoutConfiguration() : void
        {
            try
            {
                cleanUp();
                EntityManager.instance.openConnection();
            }
            catch ( e : Error )
            {
                Assert.assertTrue(e is ConfigurationError);
            }
            cleanUp();
        }

        [Test]
        /**
         * Tests a database opening the closing process
         */
        public function closeConnection() : void
        {
            var success : Boolean = false;
            EntityManager.instance.configuration = configReadMode;
            EntityManager.instance.openConnection();
            EntityManager.instance.closeConnection();
            success = true;
            Assert.assertTrue(success);
            cleanUp();
        }

        [Test]
        /**
         * Tries a full transactional process
         */
        public function transactionProcess() : void
        {
            var transactionProcessed : Boolean = false;
            EntityManager.instance.configuration = configReadMode;
            EntityManager.instance.openConnection();
            EntityManager.instance.beginTransaction();
            EntityManager.instance.commit();
            EntityManager.instance.beginTransaction();
            EntityManager.instance.rollback();
            transactionProcessed = true;
            Assert.assertTrue(transactionProcessed);
            cleanUp();
        }

        [Test]
        public function findAll() : void
        {
            EntityManager.instance.configuration = configGenericDb;
            EntityManager.instance.openConnection();
            prepareSimpleTable(configGenericDb.connection);
            var result : ArrayCollection = EntityManager.instance.findAll(StringModel);
            Assert.assertEquals(result.length, 2);
            Assert.assertTrue(result.getItemAt(0) is StringModel);
            Assert.assertTrue(result.getItemAt(1) is StringModel);
            Assert.assertEquals(result.getItemAt(0).name, 'hello');
            Assert.assertEquals(result.getItemAt(1).name, 'world');
            cleanUp();
        }

    }
}
