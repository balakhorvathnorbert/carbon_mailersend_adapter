require "http"
require "json"
require "carbon"
require "./carbon_mailersend_extensions"

class Carbon::MailersendAdapter < Carbon::Adapter
  private getter api_key : String

  def initialize(@api_key)
  end

  def deliver_now(email : Carbon::Email)
    Carbon::MailersendAdapter::Email.new(email, api_key).deliver
  end

  class Email
    BASE_URI       = "api.mailersend.com"
    MAIL_SEND_PATH = "/v1/email"
    private getter email, api_key

    def initialize(@email : Carbon::Email, @api_key : String)
    end

    def deliver
      client.post(MAIL_SEND_PATH, body: params.to_json).tap do |response|
        unless response.success?
          raise JSON.parse(response.body).inspect
        end
      end
    end

    def params
      data = {
        from:             from,
        to:               to_mailersend_address(email.to),
        subject:          email.subject,
        html:             email.html_body,
        text:             email.text_body
    }

      if template_id = email.template_id
        data = data.merge!({"template_id" => template_id})
      end

      data
    end

    private def to_mailersend_address(addresses : Array(Carbon::Address))
      addresses.map do |carbon_address|
        {
          email: carbon_address.address,
          name:  carbon_address.name,
      }
      end
    end

    private def reply_to_params
      if reply_to_address
        {email: reply_to_address}
      end
    end

    private def reply_to_address : String?
      reply_to_header.values.first?
    end

    private def reply_to_header
      email.headers.select do |key, _value|
        key.downcase == "reply-to"
      end
    end

    private def headers : Hash(String, String)
      email.headers.reject do |key, _value|
        key.downcase == "reply-to"
      end
    end

    private def from
      {
        email: email.from.address,
        name:  email.from.name,
      }
    end

    @_client : HTTP::Client?
    private def client : HTTP::Client
      @_client ||= HTTP::Client.new(BASE_URI, port: 443, tls: true).tap do |client|
        client.before_request do |request|
          request.headers["Authorization"] = "Bearer #{api_key}"
          request.headers["content-type"] = "application/json"
          request.headers["accept"] = "application/json"
        end
      end
    end
  end
end
