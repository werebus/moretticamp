# frozen_string_literal: true

module ApplicationHelper
  def back_link
    if controller.respond_to?(:request)
      referrer = controller.request.env['HTTP_REFERER']
      if referrer.present?
        uri = URI(referrer)
        return referrer if uri.scheme != 'javascript' && uri.path != '/'
      end
    end
    'javascript:history.back()'
  end

  def page_title
    title = 'Il Campo Moretti'
    title += " - #{content_for :title}" if content_for? :title
    return title
  end
end
