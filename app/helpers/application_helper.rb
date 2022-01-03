# frozen_string_literal: true

module ApplicationHelper
  def comment_lines(text)
    # Each individual line is escaped, the remainder of the output are static
    # strings defined in this method. `.html_safe` is safe in this context.
    # rubocop:disable Rails/OutputSafety
    text.each_line.map do |line|
      "<!-- #{escape_once(line.chomp)} -->"
    end.join("\n").html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def icon(style, name, text = nil)
    tag.i(nil, class: [style, "fa-#{name}"]).then do |html|
      html + " #{text}".presence
    end
  end

  def page_title
    title = 'Il Campo Moretti'
    title += " - #{content_for :title}" if content_for? :title
    title
  end
end
