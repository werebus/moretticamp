%w(all screen print).each do |s|
  Rails.application.config.assets.precompile << "application-#{s}.css"
end
