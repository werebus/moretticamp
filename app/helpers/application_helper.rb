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

  def comment_lines(text)
    text.each_line.map { |line| "<!-- #{line.chomp} -->" }.join("\n").html_safe
  end

  def icon(style, name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end

  def page_title
    title = 'Il Campo Moretti'
    title += " - #{content_for :title}" if content_for? :title
    title
  end
end
