class Video < ActiveRecord::Base

  belongs_to :user

  validates_uniqueness_of(:url, :message => "You have to enter a url")
  validates_presence_of(:url, :message => "You have to enter a url")
end
