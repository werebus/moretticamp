module PasswordFormHelper
  def password_form(path_method, token, button_text)
    render partial: 'devise/shared/password_form',
      locals: {path_method: path_method,
               token: token,
               button_text: button_text}
  end
end
