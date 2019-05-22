require 'spec_helper'

describe "new user signup" do
  it 'allows the user to fill out the form and sign up' do
    skip "Figure out what's going wrong with the js tests here"

    visit root_path
    find('[rel="signup"]').click
    fill_in "account_name", :with => "Hackraise"
    fill_in "person_name", :with => "Jess Brown"
    fill_in "user_email", :with => "helper@hackraise.com"
    fill_in "user_password", :with => "xxx12223xxx"
    click_on "Sign up and start using Hackraise!"

    expect(page).to have_selector('h1', text: "Try it out and see how Hackraise works.")
  end

  context "when filling out the form with something invalid" do
    it 'returns the user to the page with an error message' do
      visit root_path
      find('[rel="signup"]').click
      fill_in "account_name", :with => "Hackraise"
      fill_in "person_name", :with => "Jess Brown"
      fill_in "user_email", :with => "helper@hackraise.com"
      fill_in "user_password", :with => "short"
      click_on "Sign up and start using Hackraise!"
      expect(page).to have_selector(".panel-title", text: "Oops! Something went wrong.")
      expect(page).to have_selector("body", "Password is too short (minimum is 8 characters)")
    end
  end

  context 'if a user visits the signup but they are a returning user' do
    let(:user) { FactoryGirl.create :user_with_account, email: 'helper@hackraise.com', password: 'xxx12223xxx' }
    let!(:person) { create(:person, user: user, name: 'Hello Kitty', email: 'kitty@example.com', username: 'kitty', account_id: user.accounts.first.id) }

    it 'returns the user to the inbox not the signup' do
      visit root_path
      find('[rel="signup"]').click
      visit root_path

      click_on 'Sign in'

      fill_in "user_email", :with => "helper@hackraise.com"
      fill_in "user_password", :with => "xxx12223xxx"

      click_on 'Sign in'

      expect(page.current_path).to match("inbox")
    end
  end
end
