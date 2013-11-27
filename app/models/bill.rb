class Bill < ActiveRecord::Base

    belongs_to :user, :foreign_key => "user_id"

      #Creates list of states for _form.rhtml under billing view
      STATE_SELECT = [
      [ "Alambama", "AL" ],
      [ "Alaska", "AK" ],
      [ "Arizona", "AZ" ],
      [ "Arkansas", "AR" ],
      [ "California", "CA" ],
      [ "Colorado", "CO" ],
      [ "Connecticut", "CT" ],
      [ "Delaware", "DE" ],
      [ "District of Columbia", "DC" ],
      [ "Florida", "FL" ],
      [ "Georgia", "GA" ],
      [ "Hawaii", "HI" ],
      [ "Idaho", "ID" ],
      [ "Illinois", "IL" ],
      [ "Indiana", "IN" ],
      [ "Iowa", "IA" ],
      [ "Kansas", "KS" ],
      [ "Kentucky", "KY" ],
      [ "Louisiana", "LA" ],
      [ "Maine", "ME" ],
      [ "Maryland", "MD" ],
      [ "Massachusetts", "MA" ],
      [ "Michigan", "MI" ],
      [ "Minnesota", "MN" ],
      [ "Mississippi", "MS" ],
      [ "Missouri", "MO" ],
      [ "Montanna", "MT" ],
      [ "Nebraska", "NE" ],
      [ "Nevada", "NV" ],
      [ "New Hampshire", "NH" ],
      [ "New Jersey", "NJ" ],
      [ "New Mexico", "NM" ],
      [ "New York", "NY" ],
      [ "North Carolina", "NC" ],
      [ "North Dakota", "ND" ],
      [ "Ohio", "OH" ],
      [ "Oklahoma", "OK" ],
      [ "Oregon", "OR" ],
      [ "Pennsylvania", "PA" ],
      [ "Rhode Island", "RI" ],
      [ "South Carolina", "SC" ],
      [ "South Dakota", "SD" ],
      [ "Tennessee", "TN" ],
      [ "Texas", "TX" ],
      [ "Utah", "UT" ],
      [ "Vermont", "VT" ],
      [ "Virginia", "VA" ],
      [ "Washington", "WA" ],
      [ "West Virginia", "WV" ],
      [ "Wisconsin", "WI" ],
      [ "Wyoming", "WY"]
    ].freeze
      
      #Creates list of credit card types for _form.rhtml under billing view
      CARD_TYPE = [
      [ "American Express", "AMEX" ],
      [ "Master Card", "MC" ],
      [ "Visa", "VI"]
    ].freeze
    
      #Creates list of credit card expiration months for _form.rhtml under billing view
      EXP_MONTH = [
      [ "01", "01" ],
      [ "02", "02" ],
      [ "03", "03" ],
      [ "04", "04" ],
      [ "05", "05" ],
      [ "06", "06" ],
      [ "07", "07" ],
      [ "08", "08" ],
      [ "09", "09" ],
      [ "10", "10" ],
      [ "11", "11" ],
      [ "12", "12"]
    ].freeze
    
      #Creates list of credit card expiration years for _form.rhtml under billing view
      EXP_YEAR = [
      [ "06", "06" ],
      [ "07", "07" ],
      [ "08", "08" ],
      [ "09", "09" ],
      [ "10", "10" ],
      [ "11", "11" ],
      [ "12", "12" ],
      [ "13", "13" ],
      [ "14", "14"]
    ].freeze
    
        validates_presence_of :name_on_card, :street_address, :city, :state, 
                              :zip_code, :cc_type, :cc_number, :cc_exp_month, 
                              :cc_exp_year
                              
        validates_numericality_of :zip_code, :cc_number
        
        validates_uniqueness_of :cc_number, :on => :create

end
