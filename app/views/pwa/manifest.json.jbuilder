# frozen_string_literal: true

json.name 'Moretti-Swain Camp Calendar'
json.short_name 'Moretti.camp'
json.background_color '#ffffff'
json.theme_color '#006611'
json.start_url '/'
json.display 'standalone'
json.scope '/'

json.icons do
  json.child! do
    json.src asset_path('icon-192.png')
    json.sizes '192x192'
    json.type 'image/png'
  end
  json.child! do
    json.src asset_path('icon-512.png')
    json.sizes '512x512'
    json.type 'image/png'
  end
  json.child! do
    json.src asset_path('icon-512-mask.png')
    json.sizes '512x512'
    json.type 'image/png'
    json.purpose 'maskable'
  end
end
