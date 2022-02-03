# Aka 

aka is a development tool that generates permanent alias on the fly. 

[![Gem Version](https://badge.fury.io/rb/aka2.svg)](https://badge.fury.io/rb/aka2)

### Motivation
I use terminal with alias for work everyday. And I realise that to fully control my work flow, I would need to
manipulate the shortcuts in real time. Since there is no better way to control the shortcuts, I created my own.

Aka saves me time and allow me to achieve productivity through the creation of quick shortcut.

### The Workflow Manager for your Everyday Project


In other words, a delightful way to manage and grow your terminal shortcuts.

aka generate/edit/destroy/find permanent aliases with a single command.

aka requires ruby and is built for bash and zsh users.

| Features                  | alias                        | aka                    |
| :-----------------------: |:----------------------------:| :---------------------:|
| Generate alias            |  ✅                          | ✅                     |
| Destroy alias             |  ✅                          | ✅                     |
| Find and show alias       |  ✅                          | ✅                     |
| Show last few added alias |  -                           | ✅                     |
| Edit alias                |  -                           | ✅                     |
| Count alias               |  -                           | ✅                     |
| Auto reload dot file      |  -                           | ✅                     |
| Show usage                |  -                           | ✅                     |
| Persistency               |  -                           | ✅                     |
| Add your last command     |  -                           | ✅                     |
| Export Alias              |  -                           | ✅                     |
| Group your Aliases        |  -                           | ✅                     |
| Add Alias to Project      |  -                           | ✅                     |

## Installation

    gem install aka2
    aka setup

If you wish to setup aka again:

    aka setup --reset

Note: You may need to use `sudo aka setup --reset`

## Usage

To generate new alias

    aka generate hello="echo helloworld"
    aka g hello="echo helloworld"
    aka g hello="echo helloworld" --group basic

To destroy existing alias

    aka destroy hello
    aka d hello

To edit existing alias

    aka edit hello

To edit alias name

    aka edit hello --name

To find an alias

    aka find hello

To list all system aliases

    aka list
    aka list 20
    aka list --number


To export your alias into a proj.aka

    aka export group_name

To list project alias

    aka proj

To list all commands of aka

    aka help

## Known issues

* aka is designed for controlling personal work flow. It is not ready for production server or multi-user environment. 

* a missing `.bash_profile` file will require it to be created manually (ie `touch ~/.bash_profile`)


## Requirement

Ruby

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ytbryan/aka

## License

Aka is released as an open source project under the license of [The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

## Contact

[@ytbryan](http://www.twitter.com/ytbryan) & 📮 Bryan Lim ytbryan@gmail.com
