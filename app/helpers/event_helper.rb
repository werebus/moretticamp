# frozen_string_literal: true

module EventHelper
  def calendar_tip
    <<~TIP.tr("\n", ' ')
      Use this address to subscribe to the Camp calendar in another calendar
      application (e.g. Google Calendar). Click the button to copy the address
      to your clipboard.
    TIP
  end

  def owner_dropdown(form, event)
    selected = event.persisted? ? event.user_id : current_user.id
    form.collection_select :user_id, User.order(:first_name, :last_name), :id, :full_name,
                           selected:, include_blank: true, label: 'Schedule For'
  end
end
