require 'rails_helper'

RSpec.describe Customer, type: :model do
  customer = Customer.new(title: "Mr", first_name: "Dddd", last_name: "wwww")
  customer_no_title = Customer.new(title: nil, first_name: "Dddd", last_name: "wwww")
  describe '#full_name' do
    it 'prints out the full name if all info complete' do
      expect(customer.full_name).to eq("Mr Dddd wwww")
    end    
  end
  describe '#full_name' do
    it 'prints out the full name with no title' do
      expect(customer_no_title.full_name).to eq("Dddd wwww")
    end    
  end
end
