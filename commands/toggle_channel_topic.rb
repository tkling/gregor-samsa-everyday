#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/client"

class ToggleChannelTopic
  include Client

  def initialize
    options = config["toggle_topic"] || {}
    @channel = options["channel"]
    @topics = options.values_at(*(topic_names = %w[topic_1 topic_2])).compact

    if @topics.size != 2
      raise ArgumentError, "#{topic_names.join(" & ")} need to be present in #{config_file}"
    end

    @toggle_matrix = @topics.permutation.to_h
  end

  def call
    info = slack.conversations_info(channel: @channel, as_user: true)
    current_topic = info.dig("channel", "topic", "value")
    next_topic = @toggle_matrix[current_topic] || @topics.first
    slack.conversations_setTopic(channel: @channel, topic: next_topic)
  end
end

if $0 == __FILE__
  ToggleChannelTopic.new.call
end
