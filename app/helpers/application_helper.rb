# frozen_string_literal: true

module ApplicationHelper
  def comment_lines(text)
    text.each_line.map { |line| "<!-- #{line.chomp} -->" }.join("\n").html_safe
  end

  def icon(style, name, text = nil, html_options = {})
    if text.is_a?(Hash)
      html_options = text
      text = nil
    end

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
