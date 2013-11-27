class Bid < ActiveRecord::Base
        belongs_to :user, :foreign_key => "user_id"
        belongs_to :post, :foreign_key => "post_id"
        
        #Validates that "amount" field from /views/bid/place.rhtml is a valid number
        validates_numericality_of :amount
end
