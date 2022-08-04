
Rails.application.config.OAuth = OAuth2::Client.new(Rails.application.credentials[:client_id],
                                                    Rails.application.credentials[:client_secret],
                                                    site: 'https://eu.battle.net')