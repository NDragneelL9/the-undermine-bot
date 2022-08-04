# frozen_string_literal: true

# Main class to handle telegram bot commands
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  # Token to get access to blizzard API
  @access_token = nil

  # use callbacks like in any other controller
  around_action :with_locale
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  # def message(message)
  #   # store_message(message['text'])
  # end

  # For the following types of updates commonly used params are passed as arguments,
  # full payload object is available with `payload` instance method.
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  def start!(_word = nil, *_other_words)
    # do_smth_with(word)

    # full message object is also available via `payload` instance method:
    # process_raw_message(payload['text'])
    # respond_with :message, text: t('.hi')
    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` is taken from `message` when it's available.
    # response = from ? "Hello #{from['username']}!" : 'Hi there!'

    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: t('.content', first_name: from['first_name'])

    # `reply_with` also sets `reply_to_message_id`:
    # reply_with :photo, photo: File.open('party.jpg')
  end

  def wow_token!(_server = nil, *)
    respond_with :message, text: 'Calling blizzard...'

    # Token request url
    response = RestClient::Request.execute(method: :get,
                                           url: 'https://eu.api.blizzard.com/data/wow/token/index',
                                           timeout: 10,
                                           headers: { Authorization: "Bearer #{auth_token}",
                                                      params: { namespace: 'dynamic-eu',
                                                                locale: 'en_GB' } })
    # answer with current token price
    h_response = JSON.parse(response.body)
    wow_token_price = h_response['price']
    respond_with :message, text: wow_token_price
  end

  private

  def auth_token
    @access_token = Rails.configuration.OAuth.client_credentials.get_token if !@access_token || @access_token.expired?

    @access_token.token
  end

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    from['language_code']&.to_sym
  end
end
