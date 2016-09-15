require 'rails_helper'

RSpec.describe "competitions/show", type: :view do
  before(:each) do
    @competition = assign(:competition, Competition.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
