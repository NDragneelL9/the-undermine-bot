Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController, :default
end
