class UserMailer < ActionMailer::Base
    default from: "Uppercutzz <welcome@uppercutzz.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "#Booking barber appointments is coming. Excited for @uppercutzz to launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
