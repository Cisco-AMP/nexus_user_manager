# Nexus User Manager
Script to manage Nexus users, roles, and their privileges


## Setup
Run the following script to install all required dependencies:
```
script/bootstrap
```

Either create a `.env` file based off of [.env.template](.env.template) or pass in the required values as environment variables directly to the command.


## Configuration
The configuration lives within `lib/nexus_users.yaml`. Open the file to find a few example roles with their associated nexus_privileges, and a few users with their associated roles. Modify this as necessary. The script will create users and roles that don't already exist, but will NOT create new privileges.

When creating new users, you'll also need to pass in a password for that user either in the `.env` file or as an ENV variable. The variable name will be your user's name all upcase appended with `_PASSWORD`. Ex:
```
my-user -> MY_USER_PASSWORD
```

If you're having trouble with this, simply run the script without setting anything and it'll tell you what variable name it expects to be set.


## Usage
To run the script:
```
bin/nexus_user_manager
```

View available options with:
```
bin/nexus_user_manager -h
```


## Tests
To run all, or a subset, of the unit tests run one of the following commands:
```
script/test
script/test [NAME_OF_DIRECTORY]
script/test [NAME_OF_FILE]
script/test [NAME_OF_FILE]:[LINE_NUMBER]
```
