# aka - alias' best friend
Add, edit, remove and manage alias from terminal. Grow and expand those aliases with ease.
Boost projects' productivity with some terminal shortcuts.

## Overview

| features          | alias           | aka |
| :-------------: |:-------------:| :-----:|
| add alias         | ![Yes](img/yes.png) | ![Yes](img/yes.png) |
| remove alias      | ![Yes](img/yes.png)     |   ![Yes](img/yes.png) |
| show alias |  ![Yes](img/yes.png)       |    ![Yes](img/yes.png) |
| show last few alias |  -       |    ![Yes](img/yes.png) |
| edit alias |  -       |    ![Yes](img/yes.png)  |
| count alias | -      |    ![Yes](img/yes.png) |
| persistency        |-                    |    ![Yes](img/yes.png) |
| auto reload dot file      |-  |    ![Yes](img/yes.png)|
| history | -      |    ![Yes](img/yes.png) |
| upload to server | -      |    ![Yes](img/yes.png) |
| download from server | -     |    ![Yes](img/yes.png) |


## Table of Content

* [Overview](#overview)
* [Installation](#installation)
  * [Install in one line](#single-line)
* [Command Reference](#command-reference)
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

-

## Sourcing of dot files (.bash_profile, .bashrc, .zshrc)
aka uses trap and signal to reload your dot file on the same shell so that you do not need to source the dot file manually.

## 1. aka uses ruby.
Use [rbenv](https://github.com/sstephenson/rbenv) to install ruby.

## 2. install dependencies for aka
```
aka bundle
```

## 3. update aka to a newer version
```
aka update
```
## 4. help and commands
```
aka -h
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
