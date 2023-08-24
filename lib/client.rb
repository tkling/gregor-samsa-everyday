# frozen_string_literal: true

require "slack-ruby-client"

module Client
  def slack
    return @slack if @slack

    Slack.configure do |config|
      config.token = required_env_value("SLACK_API_TOKEN")
    end

    @slack = Slack::Web::Client.new.tap do |slack|
      slack.send(:connection).headers["Cookie"] = required_env_value("SLACK_COOKIE")
    end
  end

  def required_env_value(var_name)
    ENV[var_name].tap do |value|
      raise "ENV[#{var_name}] needs to be set!" if value.nil?
    end
  end

  def config_file = "config.json"

  def config
    @config ||= JSON.load_file(config_file)
  end
end
