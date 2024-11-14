# frozen_string_literal: true

module ApplicationHelper
  DEFAULT_KEY_MATCHING = {
    alert: :danger,
    notice: :success,
    info: :info,
    secondary: :secondary,
    success: :success,
    error: :danger,
    warning: :warning,
    primary: :primary
  }.freeze

  def alert(text, alert_class, closable: true)
    options = { role: 'alert', class: ['alert', "alert-#{alert_class}", (closable ? 'alert-dismissible' : nil)] }

    content = capture do
      concat text
      if closable
        concat tag.button(type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert', 'aria-label': 'Close')
      end
    end
    tag.div(content, **options)
  end

  def comment_lines(text)
    # Each individual line is escaped, the remainder of the output are static
    # strings defined in this method. `.html_safe` is safe in this context.
    # rubocop:disable Rails/OutputSafety
    text.each_line.map do |line|
      "<!-- #{escape_once(line.chomp)} -->"
    end.join("\n").html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def display_flash_messages(closable: true, key_matching: {})
    key_matching = DEFAULT_KEY_MATCHING.merge(key_matching)
    key_matching.default = :primary

    capture do
      flash.each do |key, value|
        next if key == 'timedout'

        concat alert(value, key_matching[key.to_sym], closable:)
      end
    end
  end

  def icon(style, name, text = nil)
    tag.i(nil, class: [style, "fa-#{name}"]).then do |html|
      html + " #{text}".presence
    end
  end

  def page_title
    ['Il Campo Moretti', content_for(:title)].compact.join(' - ')
  end
end
