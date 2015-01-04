## aka - alias' best friend
add, edit, remove and manage alias from terminal. Grow and expand your aliases with ease.

#### Overview

| features          | alias           | aka |
| :-------------: |:-------------:| :-----:|
| add alias         | ![Yes](img/yes.png) | ![Yes](img/yes.png) |
| remove alias      | ![Yes](img/yes.png)     |   ![Yes](img/yes.png) |
| show alias |  ![Yes](img/yes.png)       |    ![Yes](img/yes.png) |
| edit alias |  ![No](img/no.png)       |    ![Yes](img/yes.png)  |
| persistency        |![No](img/no.png)                    |    ![Yes](img/yes.png) |
| auto reload bash File      |![No](img/no.png)  |    ![Yes](img/yes.png)|
| Interact with bash file | ![No](img/no.png)     |    ![Yes](img/yes.png) |
| Count | ![No](img/no.png)      |    ![Yes](img/yes.png) |
| History | ![No](img/no.png)      |    ![Yes](img/yes.png) |
| Upload To Server | ![No](img/no.png)      |    ![Yes](img/yes.png) |
| Download From Server | ![No](img/no.png)      |    ![Yes](img/yes.png) |
<!-- | Count |  ![No](img/no.png)       |    ![Yes](img/yes.png) |
| Count |  ![No](img/no.png)       |    ![Yes](img/yes.png) | -->

---

#### Download and use
```
curl -o /usr/local/bin/aka https://raw.githubusercontent.com/ytbryan/aka/master/aka
```

#### 0. Sourcing of Bash File
aka uses trap and signal to reload your bash file. Conventional shell command called from ruby using `system()`, `exec`, `open3`, `open4`, does not execute on the same shell.

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

#### Contact
[@ytbryan](http://twitter.com/ytbryan)

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
