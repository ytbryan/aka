## aka - alias' best friend
add, edit, remove and manage alias from terminal. Making it slightly easier to manage and grow your aliases.

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
