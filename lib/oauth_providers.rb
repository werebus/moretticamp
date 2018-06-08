# frozen_string_literal: true

OauthProvider = Struct.new :label, :name, :icon, :app_id, :app_secret

google = OauthProvider.new :google_oauth2,
                           'Google',
                           'google',
                           ENV['GOOGLE_APP_ID'],
                           ENV['GOOGLE_APP_SECRET']

facebook = OauthProvider.new :facebook,
                             'Facebook',
                             'facebook',
                             ENV['FACEBOOK_APP_ID'],
                             ENV['FACEBOOK_APP_SECRET']

twitter = OauthProvider.new :twitter,
                            'Twitter',
                            'twitter',
                            ENV['TWITTER_APP_ID'],
                            ENV['TWITTER_APP_SECRET']

OAUTH_PROVIDERS = [google, facebook, twitter].freeze
