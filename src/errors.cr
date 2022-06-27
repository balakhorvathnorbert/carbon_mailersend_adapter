module Carbon
  class CarbonError < Exception
  end

  # Raised if your email is missing both `template_id`
  # and `templates`.
  class MailersendTemplateError < CarbonError
  end

end
