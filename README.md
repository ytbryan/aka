# aka - alias' best friend
Grow and expand those aliases with ease. Boost projects' productivity with some terminal shortcuts.

Here's some of aka's features:

| features          | alias           | aka |
| :-------------: |:----------:| :-----:|
| [add alias](#aka-add)         | ![Yes](demo/yes.png) | ![Yes](demo/yes.png) |
| [remove alias](#aka-remove)      | ![Yes](demo/yes.png)     |   ![Yes](demo/yes.png) |
| [show alias](#aka-show) |  ![Yes](demo/yes.png)       |    ![Yes](demo/yes.png) |
| [show last few added alias](#aka-last) |  -       |    ![Yes](demo/yes.png) |
| [edit alias](#aka-edit) |  -       |    ![Yes](demo/yes.png)  |
| [count alias](#aka-count) | -      |    ![Yes](demo/yes.png) |
| [auto reload dot file](#aka-reload)      |-  |    ![Yes](demo/yes.png)|
| [aka usage](#aka-usage) | -      |    ![Yes](demo/yes.png) |
| [upload to server](#aka-upload) | -      |    ![Yes](demo/yes.png) |
| [download from server](#aka-download) | -     |    ![Yes](demo/yes.png) |
| [persistency](#aka-persist)        |-                    |    ![Yes](demo/yes.png) |

## Table of Content

* [Overview](#overview)
* [Installation](#installation)
  * Install in one line
* [Command Reference](#command-reference)
  * [`aka add`](#aka-add)
  * [`aka remove`](#aka-remove)
  * [`aka show`](#aka-show)
  * [`aka edit`](#aka-edit)
  * [`aka count`](#aka-count)
  * [`aka usage`](#aka-usage)
  * [`aka download`](#aka-download)
  * [`aka upload`](#aka-upload)
  * [`aka global`](#aka-global)
  * [`aka local`](#aka-local)
* [TODOs](#todos)
* [Contribute](#contribute)
* [Version History](#version-history)
* [License](#license)

## [Installation](#installation)
```
git clone https://github.com/ytbryan/aka.git ~/.aka
cd ~/.aka
./aka copy
```

[or install in a single line:](#single-line)
```
git clone https://github.com/ytbryan/aka.git ~/.aka; cd ~/.aka; ./aka copy

```
---

## [Command Reference](#command-reference)


### [`aka add`](#aka-add) - add an alias to dot file
```
   aka add hello="echo helloworld"
```

### [`aka rm`](#aka-remove) - remove an alias from dot file
```
  aka rm hello
```

### [`aka show`](#aka-show) - show an alias
```
   aka show hello
```

### [`aka edit`](#aka-edit)- edit an alias
```
aka edit hello="echo hello"
```
-

## Sourcing of dot files (.bash_profile, .bashrc, .zshrc)
aka uses trap and signal to reload your dot file on the same shell so that you do not need to source the dot file manually.


## Unaliasing of aliases
`aka rm` includes `unalias` in order to keep removed aliases from the current shell. trap and signal using `SIGUSR2` is used to achieve this.

## aka uses ruby.
Use [rbenv](https://github.com/sstephenson/rbenv) to install ruby.

## install dependencies for aka
```
aka bundle
```
## help and commands
```
aka -h
```


## Run tests

```
aka test
```

## [TODOs](#todos)
- move the script to rubygems
- complete the tests

## [Contribute](#contribute)
- Question? Please contact me at [@ytbryan](http://twitter.com/ytbryan)
- Please feel free to contribute via [a pull request](https://github.com/ytbryan/aka/compare)

## [Version History](#version-history)
-

## [License](#license)
[The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

Copyright (c) 2014 - 2015 ytbryan, Bryan Lim <ytbryan@gmail.com>

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
