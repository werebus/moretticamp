# frozen_string_literal: true

# Actions in this controller will be scraped and added to the routes as
# /:action_name  So, you can't use action names that confict with other
# routes in the application.  The call to "render" is technically
# optional
class PagesController < ApplicationController
  def documents
    render
  end
end
