# aka - The Missing Alias Manager

[![Gem Version](https://badge.fury.io/rb/aka2.svg)](http://badge.fury.io/rb/aka2)

aka generate/edit/destroy/find permanent aliases with a single command.

aka2 requires ruby and is built for bash and zsh users.

## Installation

    $ gem install aka2
    $ aka setup

If you wish to reinstall aka setup

    $ aka setup --reset

## Usage

To generate new aka

    $ aka generate hello="echo helloworld"
    $ aka g hello="echo helloworld"

To destroy aka

    $ aka destroy hello
    $ aka d hello

To edit aka command

    $ aka edit hello

To edit aka alias name

    $ aka edit hello --name

To find a aka command

    $ aka find hello

To list all aka created

    $ aka list
    $ aka list 20
    $ aka list --number

To list down available command

    $ aka help

## Requirement

Ruby

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ytbryan/aka-gem.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
