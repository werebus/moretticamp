module EventHelper
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
