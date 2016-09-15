require 'rails_helper'

RSpec.describe "competitions/edit", type: :view do
  before(:each) do
    @competition = assign(:competition, Competition.create!())
  end

  it "renders the edit competition form" do
    render

    assert_select "form[action=?][method=?]", competition_path(@competition), "post" do
    end
  end
end
