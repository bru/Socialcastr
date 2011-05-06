# SocialCast

SocialCast gem is a ruby interface to the SocialCast REST API

## INSTALLATION

    gem install socialcastr

## Usage

    Socialcastr.configuration do |socialcast|
      socialcast.username = "user@example.com"
      socialcast.password = "password"
      socialcast.domain   = "demo.socialcast.com"
    end
    
    api = Socialcastr.api
    
    messages = Socialcastr::Message.find(:all)
    
    # old behaviour
    #  message_params = { "message[title]" => "hallo world!", "message[body]" => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."  }
    #  reply = api.add_message(message_params)
    #  message = Socialcastr::Message.parse(reply)

    # new behaviour
    message = Socialcastr::Message.new(
                  :title => "hallo world!", 
                  "body" => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
              )
    message.save


## Status

This is just the first draft of the wrapper. It can be improved in many, many ways.
The API is not completely covered either: a lot of interesing stuff, like (un)liking and attachments have been left out. 
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


