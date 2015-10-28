# Aka

### The Shortcut Manager for your Everyday Project

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
| Upload to server          |  -                           | ![Yes](assets/yes.png) |
| Download from server      |  -                           | ![Yes](assets/yes.png) |
| Persistency               |  -                           | ![Yes](assets/yes.png) |
| Add your last command     |  -                           | ![Yes](assets/yes.png) |
| Generate export           |  -                           | ![Yes](assets/yes.png) |

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

Bug reports and pull requests are welcome on GitHub at https://github.com/ytbryan/aka-gem

## License

[The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

## Contact

[@ytbryan](http://www.twitter.com/ytbryan)
