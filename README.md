## aka - alias' best friend
add, edit, remove and manage alias from terminal. Grow and expand your aliases with ease.

#### Overview

| features          | alias           | aka |
| :-------------: |:-------------:| :-----:|
| add alias         | ![Yes](img/yes.png) | ![Yes](img/yes.png) |
| remove alias      | ![Yes](img/yes.png)     |   ![Yes](img/yes.png) |
| show alias |  ![Yes](img/yes.png)       |    ![Yes](img/yes.png) |
| edit alias |  -       |    ![Yes](img/yes.png)  |
| count alias | -      |    ![Yes](img/yes.png) |
| persistency        |-                    |    ![Yes](img/yes.png) |
| auto reload bash file      |-  |    ![Yes](img/yes.png)|
| interact with bash file | -     |    ![Yes](img/yes.png) |
| history | -      |    ![Yes](img/yes.png) |
| upload to server | -      |    ![Yes](img/yes.png) |
| download from server | -     |    ![Yes](img/yes.png) |

---

#### Download and use
```
curl -o /usr/local/bin/aka https://raw.githubusercontent.com/ytbryan/aka/master/aka
```

#### 0. Sourcing of bash file
Aka uses trap and signal to reload your bash file on the same shell. Conventional shell command called from ruby using `system()`, `exec`, `open3`, `open4`, does not execute on the same shell.

#### 1. aka uses ruby.
To install ruby, go to [rbenv](https://github.com/sstephenson/rbenv)


#### 2. bundle install dependencies of aka
```
aka install
```

#### 3. update aka
```
aka update
aka version
```

#### TODOS
- move the script to rubygems

#### Contact and Contribute
- Please contact me at [@ytbryan](http://twitter.com/ytbryan)
- Please feel free to contribute via [a pull request](https://github.com/ytbryan/aka/compare)

#### License
[MIT ](http://www.opensource.org/licenses/MIT)

The MIT License (MIT)

Copyright (c) 2014 ytbryan, Bryan Lim

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
