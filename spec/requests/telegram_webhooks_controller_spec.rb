require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramWebhooksController, telegram_bot: :rails do

  describe '#start!' do
    subject { -> { dispatch_command :start } }
    it { should respond_with_message I18n.t('telegram_webhooks.start.content',  first_name: "") }
  end

  describe '#wow_token!' do
    subject { -> { dispatch_command :wow_token } }
    it { should respond_with_message 'Calling blizzard...' }
  end
end
