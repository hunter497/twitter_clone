require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign In') }
		it { should have_title('Sign In') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign In" }

			it { should have_title('Sign In') }
			it { should have_error_message('Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { create_user }
			before { valid_signin(user) }

			it { should have_title(user.name) }
			it { should have_link('Profile',	 href: user_path(user)) }
			it { should have_link('Sign Out',	 href: signout_path) }
			it { should_not have_link('Sign In', href: signin_path) }

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'example@example.com') }

				it { should have_link('Sign Out') }
				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end
	end
end
