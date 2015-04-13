# aka - alias' best friend

`Save time` by using aliases in your project. 

`Grow and expand` those terminal shortcuts (aliases) on the fly.

`Boost projects' productivity` with better terminal shortcuts.

`Built for` your terminal's happiness and productivity.

#### What's in the package?
- Add, remove, edit aliases on the fly.
- Manage them without opening your text editor.
- Auto reload your dot file after each action.
- Expand alias history to 10,000
- Append command into history after each action
- Upload and download your aliases using `aka dl` and `aka upload`.
- Manage those beloved shortcuts without breaking your workflow <3.

Check out some of the features:

| features                  | alias                        | aka                  |
| :-----------------------: |:----------------------------:| :-------------------:|
| add alias                 |  ![Yes](demo/yes.png)        | ![Yes](demo/yes.png) |
| remove alias              |  ![Yes](demo/yes.png)        | ![Yes](demo/yes.png) |
| find and show alias       |  ![Yes](demo/yes.png)        | ![Yes](demo/yes.png) |
| show last few added alias |  -                           | ![Yes](demo/yes.png) |
| edit alias                |  -                           | ![Yes](demo/yes.png) |
| count alias               |  -                           | ![Yes](demo/yes.png) |
| auto reload dot file      |  -                           | ![Yes](demo/yes.png) |
| aka usage                 |  -                           | ![Yes](demo/yes.png) |
| upload to server          |  -                           | ![Yes](demo/yes.png) |
| download from server      |  -                           | ![Yes](demo/yes.png) |
| persistency               |  -                           | ![Yes](demo/yes.png) |
| add your last command     |  -                           | ![Yes](demo/yes.png) |

## Table of Content
* [Installation](#installation)
  * [Ruby Installation](#dependency-install)
  * [Manual Installation](#manual-installation)
  * [Update aka](#update-aka)
  * [Setup the /.aka/.config file](#config)
  * [Bundle install those dependencies](#dependency)
  * [Setup auto reloading and expanded history](#setup)
* [Command Reference](#command-reference)
  * [`aka generate`](#aka-add)
  * [`aka destroy`](#aka-remove)
  * [`aka find`](#aka-show)
  * [`aka edit`](#aka-edit)
  * [`aka usage`](#aka-usage)
  * [`aka dl`](#aka-download)
  * [`aka upload`](#aka-upload)
* [Deinstallation](#deinstallation)
* [TODOs](#todos)
* [Contribute](#contribute)
* [Version History](#version-history)
* [License](#license)

## You need ruby to use aka

If you are seeing `ruby: command not found`, then you need to install ruby.

- I would recommend installing it using  [rbenv](https://github.com/sstephenson/rbenv).
- Remember to add  [ruby-build](https://github.com/sstephenson/ruby-build) and use `rbenv install <ruby_version>` to get your favorite ruby version.

## [Installation using Git  ](#git-installation)
```
git clone https://github.com/ytbryan/aka.git ~/.aka
cd ~/.aka
bundle
./aka install
```

## [Manual Setup](#manual-installation)
You can execute the following steps by calling `aka init`
1. Add this line to your .bash_profile
This line `sigusr1() { source /Users/ytbryan/.bash_profile; history -a; echo 'reloaded dot file'; }` is to make reloading after action work.
Add `trap sigusr1 SIGUSR1`
if you are using ubuntu or linux, add this line to `.bashrc` or `.zshrc`

2. Add this line `sigusr2() { unalias $1;}` is to make removing alias works.
Add `trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2`
If you are using ubuntu or linux, add this to `.bashrc` or `.zshrc` instead

3. Edit /etc/profile and add `export HISTSIZE=10000` at the end of the file
if you are using ubuntu or linux, add this to `/profile` instead

[or install with a single line:](#single-line)
```
git clone https://github.com/ytbryan/aka.git ~/.aka; cd ~/.aka; bundle install; ./aka install
```
## [Auto Setup](#auto-installation) (Recommended)



## [Install Bundle](#install-bundle)
```
sudo gem install bundle
```

## [Setup the config file](#config)
The `~/.aka/.config` file is an yml file. The default values are absolute path to my dot file and history file. If you are using `.bashrc` or `.zshrc`, please change the location value to its respective path by uncommenting the location in the `config` file. Relative path is not allowed in the `~/.aka/.config`
```
location: "/Users/ytbryan/.bash_profile" #absolute path to your dot file
history: "/Users/ytbryan/.bash_history" #absolute path to your history file
home: "/Users/ytbryan/.aka" #absolute path to .aka
```

## [Install Dependencies for aka](#dependency)

If you encounter issues like ` cannot load such file -- <GEM> (LoadError)`, please run the commands below.

```
cd ~/.aka
bundle install
```

## [Setup auto-reloading of dot file and expand bash history](#setup)

`aka init` writes to /etc/profile for expanded history. Hence, please use `sudo aka init` to give aka the permission to write to /etc/profile.

```
aka init
```
---
## [Command Reference](#command-reference)

### [aka generate [name='command']](#aka-add)
- generate an alias to dot file

```
   aka generate hello="echo helloworld"
   aka g helloagain="echo hello again"
   aka g hello --last #add the previous command
```

Many times, we need to add the previous command. use `--last` or `-l` to add the last executed command.

```
> echo "hello world"
aka g hello -l #generate alias hello="echo 'hello world'"
hello
> hello world
```

### [aka destroy [name]](#aka-remove)
- destroy an alias from dot file

```
  aka destroy hello
  aka d hello
```

### [aka find [name]](#aka-show)
- find an alias

```
   aka find hello
```

### [aka edit [name]](#aka-edit)
- edit an alias

```
aka edit hello="echo hi there"

```

## How it works
- aka writes alias to your dot file so that you do not need to open a text editor for that.
- aka uses trap and signal to reload your dot file on the same shell so that you do not need to source your dot file after each action.
- when the user executes `aka destroy` , a signal `SIGUSR2` is sent to remove the alias from the current shell.

## Run Tests
```
aka test
```

## [Remove aka ](#deinstallation)
If you must remove the aka's ruby dependency
```
sudo gem uninstall commander, highline, net-scp, colorize, minitest, safe_yaml, rake
```

if you need to remove aka,
```
rm -rf ~/.aka
```

## [TODOs](#todos)
- move the script to rubygems
- complete the tests

## [Contribute](#contribute)
- Question? Please contact me at [@ytbryan](http://twitter.com/ytbryan)
- If you have an idea to make aka better, please feel free to contribute via [a pull request](https://github.com/ytbryan/aka/compare)
- Make a copy and [fork this project](https://github.com/ytbryan/aka/fork)

## Thanks to these folks
- Luu Gia Thuy [@luugiathuy](http://www.github.com/luugiathuy)
- Koh Poh Chiat [@sockmister](https://www.github.com/sockmister)

## Tested on:
- OSX Yosemite 10.10.1
- Ubuntu 14.04.1 LTS

We need your help to test aka on various platforms. Submit an issue if you encounter a problem. State the error, platform and how to duplicate the error. Thank you.

## [Version History](#version-history)
- `0.3.78` - First tag
- `0.3.71` - First public release


## Some thoughts about Terminal Productivity

Terminal producitivity is not just about more terminal shortcuts. It's about a better terminal workflow and less reducdant steps to navigate and get things done on terminal.

It's about making things a little easier with lesser steps to get things done. It's about removing redundent steps from the day to day workflow so that to get the end result quicker.

And that's what is aka is about.


## [License](#license)

[The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

Copyright (c) 2014 ytbryan, Bryan Lim <ytbryan@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
