class Notifier < ActionMailer::Base

  # Sends an email containing a confirmation code to a newlt registered user
  def signup_thanks( user )
    # Email header info MUST be added here
    @recipients = user.email_address
    @from = "accounts@heyudo.com"
    @subject = "Thank you for registering with Heyudo"

    # Email body substitutions go here
    @body["login"] = user.login
    @body["conf_code"] = user.conf_code
  end
  
  #Re-sends login information to forgetful users
  def forgot_password( user )
    # Email header info MUST be added here
    @recipients = user.email_address
    @from = "accounts@heyudo.com"
    @subject = "Your login information"

    # Email body substitutions go here
    @body["login"] = user.login
    @body["ptp"] = user.ptp
  end

  # Send an email to a user when the have received a new internal reply
  def new_reply( receiver )
    # Email header info MUST be added here
    @recipients = receiver.email_address
    @from = "messages@heyudo.com"
    @subject = "You have a new reply on Heyudo.com"

    # Email body substitutions go here
    @body["login"] = receiver.login
  end

  # Send an email to a user when the have received a new internal message
  def new_message( receiver )
    # Email header info MUST be added here
    @recipients = receiver.email_address
    @from = "messages@heyudo.com"
    @subject = "You have a new message on Heyudo.com"

    # Email body substitutions go here
    @body["login"] = receiver.login
  end
  
  def payment_complete( receiver, post, user )
    # Email header info MUST be added here
    @recipients = receiver.email_address
    @from = "userinfo@heyudo.com"
    @subject = "Your contact information from Heyudo.com"

    # Email body substitutions go here
    @body["title"] = post.title
    @body["username"] = user.login
    @body["email"] = user.email_address
    @body["phone"] = user.phone_number
    @body["first_name"] = user.first_name
  end
  
  def been_accepted ( bidder )
    @recipients = bidder.email_address
    @from = "heyudoposts@heyudo.com"
    @subject = "You have been selected as the winning bidder!"
  end
  
  def waiting_post( emails )
    # Email header info MUST be added here
    @bcc = emails
    @from = "heyudoposts@heyudo.com"
    @subject = "You have a winner to pick!"
  end

end
