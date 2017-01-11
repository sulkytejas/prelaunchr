class UserMailer < ActionMailer::Base
  default from: "Printed Village's <designers.printedvillage.com>"

  def signup_email(user)
    @user = user
    @twitter_message = "#Get into the world of retails. Excited for @printedvillage to launch."

    mail(:to => user.email, :subject => "Thanks for signing up!")
  end
end
