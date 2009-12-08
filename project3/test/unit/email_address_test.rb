require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  
  # Test emtpy object validations
  test "invalid with empty attributes" do
    e = EmailAddress.new
    assert !e.valid?
    assert e.errors.invalid?(:label)
    assert e.errors.invalid?(:address)
    assert e.errors.invalid?(:engineer_id)
  end
  
  # Test the Address format validation
  test "Address format test" do
     e = EmailAddress.new
     e.label = "test"
     e.engineer = Engineer.first
     
     # Negative Test
     e.address = "invalid_address.com"
     assert !e.valid?
     assert e.errors.invalid?(:address)
     
     # Positive Test
     e.address = "valid_address@correct.org"
     assert e.valid?
  end
end
