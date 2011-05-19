# SocialCast

SocialCast gem is a ruby interface to the SocialCast REST API

## INSTALLATION

    gem install socialcastr

## Usage

    # configure the connection 
    Socialcastr.configuration do |socialcast|
      socialcast.username = "user@example.com"
      socialcast.password = "password"
      socialcast.domain   = "demo.socialcast.com"
    end
    
    # obtain an instance of the API (useful to directly issue get, put, post, delete commands)
    api = Socialcastr.api
    
    # find all messages (currently returns just one page - 20 elements)
    messages = Socialcastr::Message.find(:all)
   
    # build a new message object 
    message = Socialcastr::Message.new(
                  :title => "hallo world!", 
                  "body" => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
              )
    
    message.new? # => true

    # persist the message to Socialcast
    message.save

    # comment a message
    message.comment! :text => "Hallo world"

    # search for messages
    messages = Socialcastr::Message.search(:q => "test")




## Status

This is just the first draft of the wrapper. It can be improved in many, many ways.
The API is not completely covered either: some of interesing stuff, like message and comments attachments have been left out. 
One current limitation is that the parser will refuse to consider
elements that contain a dot, so I'm excluding those deliberately for the
time being (see
lib/socialcastr/sax/active_resource.rb#start_element).

Feel free to help (see Contributing below)

## TODO

* Base
  * CRUD for nested objects (comments, likes, attachments)

## Contributing to the code (a.k.a. submitting a pull request)

1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Commit and push your changes.
5. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)


## Copyright

Copyright (c) 2011 Riccardo Cambiassi. See LICENSE for details.


