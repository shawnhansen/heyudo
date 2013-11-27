class Feedback < ActiveRecord::Base

  belongs_to :user, :foreign_key => "user_id"
  belongs_to :post, :foreign_key => "post_id"
  
  UP_DOWN = [
      [ "Thumbs up", "2" ],
      [ "Thumbs down", "1" ]
    ].freeze
    
 validates_length_of :comment, :within => 5..80, :too_long => "Sorry, comments must be less than 80 characters", :too_short => "Sorry, comments must be at least 5 characters long"
 validates_presence_of :rated

end
