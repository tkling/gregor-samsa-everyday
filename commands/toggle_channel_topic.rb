#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative "../client"

class ToggleChannelTopic
  include Client

  def initialize
    options = config["toggle_topic"] || {}
    @channel = options["channel"]
    @toggle_matrix = options.values_at("topic_1", "topic_2").permutation.to_h
  end

  def call
    info = slack.conversations_info(channel: @channel, as_user: true)
    current_topic = info.dig("channel", "topic", "value")
    next_topic = @toggle_matrix[current_topic]
    return puts("Exiting, no next topic :(") if next_topic.nil?

    slack.conversations_setTopic(channel: @channel, topic: next_topic)
  end
end

if $0 == __FILE__
  ToggleChannelTopic.new.call
end
