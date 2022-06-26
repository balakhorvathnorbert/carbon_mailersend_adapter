module Carbon::MailersendExtensions
  # Define the dynamic template_id to use
  # when sending an email. This will be a
  # String value of the template defined
  # in Mailersend. If `nil`, then use the
  # Carbon template system.
  def template_id
    nil
  end
end

class Carbon::Email
  include Carbon::MailersendExtensions
end
