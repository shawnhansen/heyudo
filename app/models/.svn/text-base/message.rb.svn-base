class Message < ActiveRecord::Base

        belongs_to :user, :foreign_key => "sender_id"
        #has_one :user, :foreign_key => "receiver_id"
        belongs_to :post, :foreign_key => "post_id"
        validates_presence_of :subject, :body

end
