# AKA

## v0.1.10
added
* Introducing system alias, project alias and groups
* Added [aka proj --push ] to generate specific aka file
* Added [aka proj --load] to export certain alias group into a project directory
* Added [aka proj --save ] to generate specific aka file
* Added [aka proj] to show all project alias
* Added [aka groups] to list all groups in the system
* Added .profile as setup options. Thanks to fgperianez
* Edited test_aka.rb
* Refactor the aka code
* Remove some dependencies and set required ruby back to 2.0.0.
* Change default list to 20 aliases
* Start using aka in your projects :)

## v0.1.9
* Added -g option to add grouping to alias
* Added -g option to find grouping based on group name
* Usual clean up

## v0.1.7 + v0.1.8
* Add numbering option for list
* Add validation for list method
* Beautify aka output

## v0.1.6

* Remove unnecessary print out

## v0.1.5

* If more than one bashfile exist, user can choose setup destination
* Add edit alias's name function for user
* Add remove source from dotfile

## v0.1.4

* Rename method names
* Add reset function for user to re-setup aka

## v0.1.3

* Fix setup_aka3 bug for bashrc user

## v0.1.2

* Fix setup2 bug - export new line
* create setup_akasource

## v0.1.1

* User can use 'aka setup2' to set the config file
* Fix Bug - config file not found

## v0.1.0

* Convert aka project from [ytbran/aka](https://github.com/ytbryan/aka) to a gem.
