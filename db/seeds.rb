# Application
application = Application.create!(:name => "Sirportly")

# User
User.create!(:name => 'Adam Cooke', :username => 'adam', :email_address => 'me@adamcooke.io', :password => 'password', :password_confirmation => 'password')
User.create!(:name => 'Charlie Smurthwaite', :username => 'charlie', :email_address => 'charlie@atechmedia.com', :password => 'password', :password_confirmation => 'password')
