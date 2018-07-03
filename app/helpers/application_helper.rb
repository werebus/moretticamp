# frozen_string_literal: true

module ApplicationHelper
  def back_link
    if controller.respond_to?(:request)
      referrer = controller.request.env['HTTP_REFERER']
      uri = URI(referrer)
      if referrer && uri.scheme != 'javascript' && uri.path != '/'
        return referrer
      end
    end
    return 'javascript:history.back()'
  end
end
