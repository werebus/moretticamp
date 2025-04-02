# frozen_string_literal: true

module SeasonHelper
  def season_bootstrap_class(season)
    if !season.available?
      'warning'
    elsif season.next?
      'info'
    elsif season.current?
      'success'
    else
      'secondary'
    end
  end
end
