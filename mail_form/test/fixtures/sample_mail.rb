class SampleMail < MailForm::Base
  attributes :name, :email, :nickname
  validates :nickname, absence: true

  before_deliver do
    evaluated_callbacks << :before
  end

  after_deliver do
    evaluated_callbacks << :after
  end

  def headers
    { to: 'recipient@example.com', from: self.email }
  end

  def evaluated_callbacks
    @evaluated_callbacks ||= []
  end
end
