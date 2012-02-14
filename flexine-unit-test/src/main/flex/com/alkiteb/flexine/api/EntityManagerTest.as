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
    import com.alkiteb.flexine.query.CreateTableQuery;
    
    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.filesystem.File;
    
    import flexunit.framework.Assert;
    
    import mx.collections.ArrayCollection;
    
    import org.as3commons.logging.api.LOGGER_FACTORY;
    import org.as3commons.logging.api.getLogger;
    import org.as3commons.logging.setup.SimpleTargetSetup;
    import org.as3commons.logging.setup.target.TraceTarget;

    public class EntityManagerTest
    {

        private static var configCreateMode : SQLConfiguration;
        private static var configUpdateMode : SQLConfiguration;
        private static var configReadMode : SQLConfiguration;

        private static var configGenericDb : SQLConfiguration;

        private static var createDB : String = "api_create_test.db";
        private static var updateDB : String = "api_update_test.db";
        private static var readDB : String = "api_read_test.db";

        private static var genericDB : String = "generic_db_test.db";
        private static var genericDBEntries : Array = [];

        [Before]
        public function setUp() : void
        {
        }

        [After]
        public function tearDown() : void
        {
        }

        [BeforeClass]
        public static function setUpBeforeClass() : void
        {
            LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget());
            getLogger(EntityManagerTest).debug("Setting up EntityManagerTest test");
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
            configGenericDb.persistencePackage = "com.alkiteb.flexine.models.generic"

            getLogger(EntityManagerTest).debug("EntityManagerTest test setup complete");
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

        public static function cleanGenericDbFile() : void
        {
            try
            {
                var genDBFile : File = new File(File.applicationDirectory.resolvePath(genericDB).nativePath);
                if (genDBFile.exists)
                {
                    genDBFile.deleteFile();
                }
            }
            catch ( e : Error )
            {
                // No connection was open
            }
        }

        public function addEntries( connection : SQLConnection ) : void
        {
            var obj1 : StringModel = new StringModel();
            obj1.active = true;
            obj1.lastName = "Ghazi";
            obj1.name = "Triki";
            obj1.sent_date = new Date(1985, 11, 30);
            obj1.simpleXML = new XML(<tag><!-- Added using Flexine ORM --></tag>
                );

            genericDBEntries.push(obj1);
            EntityManager.instance.create(obj1);

            var obj2 : StringModel = new StringModel();
            obj2.active = false;
            obj2.lastName = "John";
            obj2.name = "Doe";
            obj2.sent_date = new Date(1960, 5, 15);
            obj2.simpleXML = new XML(<content><!-- Added using Flexine ORM --></content>
                );

            genericDBEntries.push(obj2);
            EntityManager.instance.create(obj2);
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
            cleanGenericDbFile();
            EntityManager.instance.configuration = configGenericDb;
            EntityManager.instance.openConnection();
            addEntries(configGenericDb.connection)
            var result : ArrayCollection = EntityManager.instance.findAll(StringModel);
            Assert.assertEquals(result.length, 2);
            for (var i : int; i < result.length; i++)
            {
                var obj : * = result.getItemAt(i);
                var origObj : * = genericDBEntries[i];
                Assert.assertTrue(obj is StringModel);
                Assert.assertEquals(obj.name, origObj.name);
                Assert.assertEquals(obj.lastName, origObj.lastName);
                Assert.assertEquals(obj.sent_date.time, origObj.sent_date.time);
                Assert.assertEquals(obj.simpleXML, origObj.simpleXML);
            }
            cleanUp();
        }

        
        [Test]
        public function update() : void
        {
            EntityManager.instance.configuration = configGenericDb;
            EntityManager.instance.openConnection();
            addEntries(configGenericDb.connection)
            var result : ArrayCollection = EntityManager.instance.findAll(StringModel);
            var obj1 : StringModel = result[0];
            EntityManager.instance.update(obj1);
        }
    }
}
