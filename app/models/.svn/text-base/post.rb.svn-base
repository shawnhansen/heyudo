class Post < ActiveRecord::Base

        #Tells acts_as_ferret plugin which columns to index
        #acts_as_ferret :fields => [ 'state', 'city', 'category', 'body', 'title' ]
        
        belongs_to :user, :foreign_key => "user_id"
        has_many :bids
        has_many :messages
        
    #Preps for file_column (plugin) image uploads
    file_column :pic_1, :magick => { :geometry => "400x300>" }
    file_column :pic_2, :magick => { :geometry => "400x300>" }
    file_column :pic_3, :magick => { :geometry => "400x300>" }
    
    def self.post_mailer
      puts "Finding all posts that need to be mailed..."
      @posts = Post.find(:all,
                         :conditions => ['mailed = 0 AND lowest_bid > 0 AND end_date < :enddate',
                                            {:enddate => Time.now}],
                         :limit => 50)
      puts "Extracting email addresses for post owners..."
      @emails = @posts.map {|post| post.user.email_address}
      if @emails.length > 0
        puts "Sending mail..."
        Notifier::deliver_waiting_post( @emails )
        puts "Updating mailed attribute for each post..."
        @posts.each {|post| post.update_attribute("mailed", 1)}
      else
        puts "No users to be mailed."
      end
    end
    
    #Creates drop down array for "recurring" field in /views/post/_form.rhtml
    RECURRING = [
      [ "Single Task", "0" ],
      [ "Continuous Service", "1" ]
    ].freeze
    
    POST_LENGTH = [
      [ "3 Days", "#{3.days.from_now.to_date}" ],
      [ "5 Days", "#{5.days.from_now.to_date}" ],
      [ "1 Week", "#{1.week.from_now.to_date}" ],
      [ "2 Weeks", "#{2.weeks.from_now.to_date}" ]
    ].freeze
    
    RATE = [
      [ "By task", "By Task" ],
      [ "Hourly rate", "Hourly rate" ]
    ].freeze
    
    #Creates drop down array for "state" field in /views/post/_form.rhtml
    STATE_SELECT = [
      [ "Alambama", "Alambama AL" ],
      [ "Alaska", "Alaska AK" ],
      [ "Arizona", "Arizona AZ" ],
      [ "Arkansas", "Arizona AR" ],
      [ "California", "California CA" ],
      [ "Colorado", "Colorado CO" ],
      [ "Connecticut", "Connecticut CT" ],
      [ "Delaware", "Delaware DE" ],
      [ "District of Columbia", "District of Columbia DC" ],
      [ "Florida", "Florida FL" ],
      [ "Georgia", "Georgia GA" ],
      [ "Hawaii", "Hawaii HI" ],
      [ "Idaho", "Idaho ID" ],
      [ "Illinois", "Illinois IL" ],
      [ "Indiana", "Indiana IN" ],
      [ "Iowa", "Iowa IA" ],
      [ "Kansas", "Kansas KS" ],
      [ "Kentucky", "Kentucky KY" ],
      [ "Louisiana", "Louisiana LA" ],
      [ "Maine", "Maine ME" ],
      [ "Maryland", "Maryland MD" ],
      [ "Massachusetts", "Massachusetts MA" ],
      [ "Michigan", "Michigan MI" ],
      [ "Minnesota", "Minnesota MN" ],
      [ "Mississippi", "Mississippi MS" ],
      [ "Missouri", "Missouri MO" ],
      [ "Montanna", "Montanna MT" ],
      [ "Nebraska", "Nebraska NE" ],
      [ "Nevada", "Nevada NV" ],
      [ "New Hampshire", "New Hampshire NH" ],
      [ "New Jersey", "New Jersey NJ" ],
      [ "New Mexico", "New Mexico NM" ],
      [ "New York", "New York NY" ],
      [ "North Carolina", "North Carolina NC" ],
      [ "North Dakota", "North Dakota ND" ],
      [ "Ohio", "Ohio OH" ],
      [ "Oklahoma", "Oklahoma OK" ],
      [ "Oregon", "Oregon OR" ],
      [ "Pennsylvania", "Pennsylvania PA" ],
      [ "Rhode Island", "Rhode Island RI" ],
      [ "South Carolina", "South Carolina SC" ],
      [ "South Dakota", "South Dakota SD" ],
      [ "Tennessee", "Tennessee TN" ],
      [ "Texas", "Texas TX" ],
      [ "Utah", "Utah UT" ],
      [ "Vermont", "Vermont VT" ],
      [ "Virginia", "Virginia VA" ],
      [ "Washington", "Washington WA" ],
      [ "West Virginia", "West Virginia WV" ],
      [ "Wisconsin", "Wisconsin WI" ],
      [ "Wyoming", "Wyoming WY"]
    ].freeze
    
    CATEGORY_SELECT = [
      [ "Automobile Service", "Automobile Service" ],
      [ "Appliance Service", "Appliance Service" ],
      [ "Business Services", "Business Services" ],
      [ "Catering", "Catering" ],
      [ "Cleaning Services", "Cleaning Services" ],
      [ "Computer Programming", "Computer Programming" ],
      [ "Computer Repair/Service", "Computer Repair/Service" ],
      [ "Electrical Service", "Electrical Service" ],
      [ "Entertainment Services", "Entertainment Services" ],
      [ "Financial Services", "Financial Services" ],
      [ "Graphic Design", "Graphic Design" ],
      [ "Home Improvement/Design", "Home Improvement/Design" ],
      [ "Items Wanted", "Items Wanted" ],
      [ "Large Construction", "Large Construction" ],
      [ "Landscaping", "Landscaping" ],
      [ "Legal Services", "Legal Services" ],
      [ "Personal (health, training, etc.)", "Personal (health, training, etc.)" ],
      [ "Photography", "Photography" ],
      [ "Plumbing", "Plumbing" ],
      [ "Transportation", "Transportation" ],
      [ "Other Services", "Other Services" ],
    ].freeze
    
    #Validates that length of string entered into "title" field in /views/post/_form.rhtml
    #is within 10 - 100 characters.
    validates_length_of :title, :within => 7..75
    #Validates that length of string entered into "body" field in /views/post/_form.rhtml
    #is within 10 - 100 characters.
    validates_length_of :body, :within => 10..1500
    #Validates that entry exists for "title", "body", and "recurring" fields in /views/post/_form.rhtml
    validates_presence_of :title, :body, :recurring, :rate, :city, :state, :end_date
    #Verifies that data entered into "cap" in /views/post/_form.rhtml is a valid number.
    validates_numericality_of :cap
                         
end
