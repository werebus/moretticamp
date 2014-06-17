OauthProvider = Struct.new :label, :name, :icon, :app_id, :app_secret

google = OauthProvider.new :google_oauth2,
                           "Google",
                           "fa-google",
                           ENV['GOOGLE_APP_ID'],
                           ENV['GOOGLE_APP_SECRET']

facebook = OauthProvider.new :facebook,
                             "Facebook",
                             "fa-facebook",
                             ENV['FACEBOOK_APP_ID'],
                             ENV['FACEBOOK_APP_SECRET']

twitter = OauthProvider.new :twitter,
                            "Twitter",
                            "fa-twitter",
                            ENV['TWITTER_APP_ID'],
                            ENV['TWITTER_APP_SECRET']

OAUTH_PROVIDERS = [google, facebook, twitter]
