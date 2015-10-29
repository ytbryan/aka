# Aka

### The Shortcut Manager for your Everyday Project

[![Gem Version](https://badge.fury.io/rb/aka2.svg)](https://badge.fury.io/rb/aka2)

aka generate/edit/destroy/find permanent aliases with a single command.

aka requires ruby and is built for bash and zsh users.

| features                  | alias                        | aka                  |
| :-----------------------: |:----------------------------:| :-------------------:|
| Generate alias                 |  ![Yes](assets/yes.png)        | ![Yes](assets/yes.png) |
| Destroy alias              |  ![Yes](assets/yes.png)        | ![Yes](assets/yes.png) |
| Find and show alias       |  ![Yes](assets/yes.png)        | ![Yes](assets/yes.png) |
| Show last few added alias |  -                           | ![Yes](assets/yes.png) |
| Edit alias                |  -                           | ![Yes](assets/yes.png) |
| Count alias               |  -                           | ![Yes](assets/yes.png) |
| Auto reload dot file      |  -                           | ![Yes](assets/yes.png) |
| Show usage                |  -                           | ![Yes](assets/yes.png) |
| Persistency               |  -                           | ![Yes](assets/yes.png) |
| Add your last command     |  -                           | ![Yes](assets/yes.png) |
| Export Alias              |  -                           | ![Yes](assets/yes.png) |
| Group your Aliases        |  -                           | ![Yes](assets/yes.png) |
| Add Alias to Project      |  -                           | ![Yes](assets/yes.png) |

## Installation

    gem install aka2
    aka setup

If you wish to setup aka again:

    aka setup --reset

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

## Requirement

Ruby

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ytbryan/aka

## License

Aka is released as an open source project under the license of [The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

## Contact

[@ytbryan](http://www.twitter.com/ytbryan)
