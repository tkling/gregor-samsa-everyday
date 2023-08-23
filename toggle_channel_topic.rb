# frozen_string_literal: true

require_relative 'client'

class ToggleChannelTopic
  include Client

  def initialize
    topics = config['toggle_topic'].values_at('topic_1', 'topic_2')
    @toggle_matrix = Hash[topics.permutation.to_a]
    @channel = config['channel']
  end

  def call
    info = slack.conversations_info(channel: @channel, as_user: true)
    current_topic = info.dig('channel', 'topic', 'value') || @toggle_matrix.first.first

    slack.conversations_setTopic(
      channel: @channel,
      topic: @toggle_matrix[current_topic])
  end
end

if $0 == __FILE__
  ToggleChannelTopic.new.call
end
