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
    if event.persisted?
      form.collection_select :user_id,
                             User.all,
                             :id,
                             :full_name,
                             include_blank: true,
                             label: 'Schedule For'
    else
      form.collection_select :user_id,
                             [User.new] + User.all,
                             :id,
                             :full_name,
                             selected: current_user.id,
                             label: 'Schedule For'
    end
  end
end
