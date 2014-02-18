require 'spec_helper'
module RequestsHelper
  def request_login(user)
    visit login_path
    fill_in 'usage_user_session[login]', :with => user.login
    fill_in 'usage_user_session[password]', :with => "123456"
    page.find(:image,"[@name='commit']").click
    page.should have_content('Successfully logged in.')
  end
end
