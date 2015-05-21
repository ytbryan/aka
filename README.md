# aka - The Missing Alias Manager

aka generate/edit/destroy/find permanent aliases with a single command. 

#Usage

```
aka generate hello="echo helloworld" 
aka destroy hello
aka edit hello
aka find hello
aka usage
aka 
```

#Install
```
git clone https://github.com/ytbryan/aka.git ~/.aka
cd ~/.aka
bundle
sudo ./aka install
sudo ./aka setup
```

#Manual Setup
Paste the following code into /etc/profile. Remember to change the path /Users/___/.bash_profile
```
export HISTSIZE=10000
sigusr2() { unalias $1;}
sigusr1() { source /Users/__/.bash_profile; history -a; echo 'reloaded dot file'; }
trap sigusr1 SIGUSR1
trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2
```
Or simply type `cd ~/.aka; sudo ./aka setup`


#Troubleshoot

```
Bryans-Air:.aka ytbryan$ aka 
Error: Type `aka init --dotfile /Users/ytbryan/.bash_profile` to set the path of your dotfile. 
Replace .bash_profile with .bashrc or .zshrc if you are not using bash.
```
aka init --dotfile /Users/ytbryan/.bash_profile #change the path accordingly


#Requirement 
Ruby

#[License](#license)

[The MIT License (MIT)](http://www.opensource.org/licenses/MIT)

#Contact 
[@ytbryan](http://www.twitter.com/ytbryan)