require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  # Test emtpy object validations
  test "invalid with empty attributes" do
    p = PhoneNumber.new
    assert !p.valid?
    assert p.errors.invalid?(:label)
    assert p.errors.invalid?(:number)
    assert p.errors.invalid?(:engineer_id)
  end
  
  # Test the Phone Number format validation
  test "Phone Number format test" do
     p = PhoneNumber.new
     p.label = "test"
     p.engineer = Engineer.first
     # Negative Test
     p.number = "203-invalid-number"
     assert !p.valid?
     assert p.errors.invalid?(:number)
     
     # Positive Test
     p.number = "111-222-3333"
     assert p.valid?
  end
end
