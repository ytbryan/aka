
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  sudo apt-get install git
elif [[ "$OSTYPE" == "darwin"* ]]; then
  #mac os x
  brew install git
fi

#clone rbenv
git clone https://github.com/sstephenson/rbenv.git

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
  #mac os x
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  echo 'Mac OSX'
fi

#install ruby
rbenv install 2.2.3

gem install bundler rails
