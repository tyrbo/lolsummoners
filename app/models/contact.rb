class Contact < MailForm::Base
  attribute :email,   validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject, validate: true
  attribute :message, validate: true

  def headers
    {
      :subject => "[SITE] #{subject}",
      :to => "admin@lolsummoners.com",
      :from => "#{email}"
    }
  end
end
