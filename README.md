# notekeeper

# Asynchronus Programming in Flutter

Since Dart is Single threaded so is , Flutter. Normally Android Aplication are Multithreaded, because they use multiple threads to run different process parallaly. But in Flutter all the parallel processing is performed on single thread, using Asynchronus programming with the help of Three APIs.
1. future
2. async
3. await


# SQLite DataBase in Flutter

SQLite an in-process library SQL database Engine, that implements 
Self-contained -- requires less support from exteranl libraries and platform independent.
Serverless--reads and writes database files on the disks.locally  on the device
Zero configuration -- no installation and setup required, 
Transactional-- transaction either completes or not..no in between

Plugin -- SQFLite Plugin --let us access SQLite database in both iOS and Android ..Must include dependency in pubsec.yaml file.
This Plugin only deals with Map object,i.e., only saves Map objects to SQLite database.
Therefore convert data into map obeject.
Similarly to  fetch data from database, first convert it from map object to required data type to use it in the application.


# Our Requirement for SQLite Database Implementation
1. Model Class -To represent Note Object
2.Database helper -to perform CRUD operations.(Inset , update, etc)
3.Connect database to UI.



# Add Dependecies
sqflite:any  
path-provider:any  // commonly used location on file system
intl: 0.16.1    //This package provides internationalization and localization facilities, including message translation, plurals and genders, date/number formatting and parsing, and bidirectional text.

# Model Class Implementation
add models package
create dart file for "note" object.. which  will be stored in note.db database
just like any SQL table 
columns(ID,Title,Description,Priority,Date).

1.create class and initialize all the properties(attributes) 
2.define setter and getter function for  all the properties
3.define  object conversion(Note<->Map) fucntions for map object to store and getch from database. NOTE OBJECT TO MAP OBJECT.


# Database Helper Class
Creating Singleton Object
define INSERT,FETCH,DELETE,UPDATE functions. CRUD operations

Sigleton Object->instance which will be initialized only once,throughout the lifecycle of our app. We use stastic key word.

1.define and intialize all the database attributes,along with database table.
2.create and intialize the database 
3.create getter for database  -- returns old DB if exist or create new and return
4.define CRUD operations
    SQL queries can be passed using any of the following two methods, 
    1) rawQuery,rawInsert,rawDelete,rawUpdate-- ('COMPLETE SQL QUERY')  
    OR
    2) query, insert , delete , update -- ('JUST PASS THE ARGUMENTS ')

5. define a function to count total notes in our database.


