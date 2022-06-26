# mailersend_adapter

This is luckyframework/carbon's adapter for mailersend: https://www.mailersend.com

https://github.com/luckyframework/carbon

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     carbon_mailersend_adapter:
       github: balakhorvathnorbert/carbon_mailersend_adapter
   ```

2. Run `shards install`

## Usage

Set your `MAILERSEND_API_KEY` variable inside `.env`

and update your `config/email.cr` file with:

```crystal
require "carbon_mailersend_adapter"

BaseEmail.configure do |settings|
  if Lucky::Env.production?
    mailersend_key = mailersend_key_from_env
    settings.adapter = Carbon::MailersendAdapter.new(api_key: mailersend_key)
  else
    settings.adapter = Carbon::DevAdapter.new(print_emails: true)
  end
end

private def mailersend_key_from_env
  ENV["SMAILERSEND_API_KEY"]? || raise_missing_key_message
end

private def raise_missing_key_message
  puts "Missing SENDINBLUE_API_KEY. Set the MAILERSEND_API_KEY env variable to '' if not sending emails, or set the MAILERSEND_API_KEY ENV var.".colorize.red
  exit(1)
end

```

## Contributing

1. Fork it (<https://github.com/your-github-user/mailersend_adapter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Norbi Balák-Horváth](https://github.com/balakhorvathnorbert) - creator and maintainer
