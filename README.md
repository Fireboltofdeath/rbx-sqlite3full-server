### Please be careful! This IS still sql, and sql injection can be possible if you do not [bind your parameters!](#documentation)

# rbx-sqlite3full-server
Full access SQL api from roblox.

# node-rbx-sqlite3-server
This is meant for users who already know how to use Node.JS;
[Roblox Api](#roblox-api);

# HOW TO USE
This is made to be used on Glitch or your own VPS. I highly recommending investing in your own VPS, however it is up to you.

# Glitch Tutorial
### Creating an account

To create an account, visit the [glitch website](https://glitch.com/) and in the top right, click Sign In. I recommend signing in through a github account, however you can choose any of the listed options.

### Creating a new project

After you create an account, or login you must now create a new project. Click [here](https://glitch.com/edit/#!/remix/hello-express) to create a new express project.
Before you setup anything, you'll want to goto the top left of the website and select the dropdown, which will have a random name next to it. You may change the name of your project, and the description. You'll also want to click the lock icon, which will make your repo private so no one can see your private keys. If you would like to keep the project public you may use the (KEY).env file which will not show to anyone except editors.

### Setting up your project

You'll want to replace the files in your glitch project with the files in this repo's [/nodejs](https://github.com/Fireboltofdeath/rbx-sqlite3full-server/tree/master/nodejs) directory. All files should already be there and can be replaced, but if they aren't you can click the New File button and type the name of the files.

## Configuring the project

Inside of server.js, you will see several variables above a comment, do not modify anything below unless you know what you're doing.
Configurations settings:

- **databaseFile**: This is the file where your SQLite3 data is stored. Changing this will reset all data.
- **ApiToken**: This is the token you will use to access the database. I highly recommend using a password generating and storing the password in your .env file
- **startupQueries**: All queries in this will run every time the node app is restarted. (if you create tables, you should add "IF NOT EXISTS" to prevent errors)

# Roblox Api

The roblox API is located in the [/roblox](https://github.com/Fireboltofdeath/rbx-sqlite3full-server/tree/master/roblox) subdirectory in this repo.
Copy the source of sql.lua into a new ModuleScript in roblox studio. After doing so, you can require the module and it'll return a few configuration options.
- **ApiUrl**: Set this to the url of your glitch (or website) without a trailing slash. EX: https://example.fireboltofdeath.tk
- **Token**: Set this to the token you set inside of your server.js

## Documentation


#### Module
###### sql:Query(string Query);
This creates a [statement](#statement-object) object. It is highly recommended you use prepared statements. To use prepared statements, you must put a question mark in place of a parameter. Prepared statements only work on parameters. 
```lua 
sql:Query("SELECT * FROM `table` WHERE `name`=?");
```

#### Statement Object
###### statement:Bind(...Parameters)
Bind the parameters specified in the query. First argument is the first occuring ? and so on. Without using prepared statements, you put yourself at risk of SQL injection.

```lua
statement:Bind("First Parameter", "Second Parameter", "Third", "Fourth", "Fifth")
```

###### statement:Run(...Parameters)
If Parameters is specified, it'll internally called statement:Bind(...Parameters)

Execute a SQL query that DOES NOT return results. You cannot call this function on queries that return data.

###### statement:Get(...Parameters)
If Parameters is specified, it'll internally called statement:Bind(...Parameters)

Execute a SQL query that DOES return results. You cannot call this function on queries that do not return data.

#### Return results

##### Response table
The response table contains information about the request.

Success: If the request succeeded

Message: Only shows if failed, less detailed error message

Error: Will only show if the SQL query itself failed, and will contain why the query failed.

ServerResponse: Server's response, containing more detailed response.



Statement:Get and statement:Run both return several values, to get all values you must do `local A, B, C = ...`
###### statement:Get(...Parameters)
First Value: boolean Success

Second Value: (if success) Query results (if failure) Response table

Third Value: (if success) Response table

##### statement:Run(...Parameters)
First Value: boolean Success

Second Value: Response table

