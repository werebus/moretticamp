RSpec.configure do |config|
  # additional factory_bot configuration

  #config.before(:suite) do
    #FactoryBot.lint
  #end
  config.include FactoryBot::Syntax::Methods
end
