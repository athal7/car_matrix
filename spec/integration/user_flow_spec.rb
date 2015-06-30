require 'spec_helper'

describe "User Flow" do
  let!(:car) { Car.create({:num_seats => 5}) }
  context "When on the home page" do
    before { visit root_path }
    it "is able to go to the new flight page" do
      click_link "Submit New Flight"
      current_path.should == new_flight_path
    end
    it "is able to get to the admin screen" do
      click_link "Admin"
      current_path.should == admin_path
    end
    it "is returned to it's current location when clicking the logo" do
      click_link "CarMatrix"
      current_path.should == root_path
    end
    it "is returned to it's current location when clicking the view car matrix link" do
      click_link "View Car Matrix"
      current_path.should == root_path
    end
  end
  context "Submitting a new flight" do
    before { visit new_flight_path }
    it "can submit a new flight" do
      content = ['Andrew Thal', '1234', 'United']
      fill_in 'flight_traveler_name', :with => content[0]
      fill_in 'flight_flight_number', :with => content[1]
      fill_in 'flight_airline', :with => content[2]
      click_link_or_button "Create Flight"
      current_path.should == root_path
      content.each do |c|
        page.should have_content c
      end
    end
  end
end
