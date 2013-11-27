class Contact < ActiveRecord::Base

      belongs_to :user
      
      CATEGORY = [
      [ "General question", "General question" ],
      [ "Login issues", "Login issues" ],
      [ "I'm confused about a feature", "I'm confused about a feature" ],
      [ "Something's not working", "Something's not working" ],
      [ "Report abuse", "Report abuse" ],
      [ "Pat on the back :)", "Pat on the back :)" ]
    ].freeze

      validates_presence_of :category, :email_address, :message

end
