require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base

        has_many :posts
        has_many :bids
        has_many :messages
        has_many :videos
        has_one :bill
        
     #Preps for file column user pic upload
     file_column :pic, :magick => { :geometry => "150x150>" }

  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
    
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

  validates_length_of :login, :within => 3..20
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation, :email_address, :first_name
  validates_uniqueness_of :login, :email_address, :on => :create
  validates_confirmation_of :password, :on => :create 
  validates_acceptance_of :agree, :message => "You must accept the Terms of Service before you can use Heyudo"    
end
