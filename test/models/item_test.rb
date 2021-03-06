require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "assigns a number" do
    borrow_policy = create(:borrow_policy)
    item = build(:item, number: nil, borrow_policy: borrow_policy)
    item.save!

    assert item.number
  end

  test "it has a due_on date" do
    loan = create(:loan, due_at: Date.tomorrow.end_of_day)
    loan.item.reload
    assert Date.tomorrow, loan.item.due_on
  end

  test "it is not available" do
    loan = create(:loan)
    loan.item.reload
    refute loan.item.available?
  end

  test "it is available" do
    assert create(:item).available?
  end

  test "validations" do
    item = Item.new(status: nil)

    refute item.valid?

    assert_equal ["can't be blank"], item.errors[:name]
    assert_equal ["is not included in the list"], item.errors[:status]
  end

  test "strips whitespace before validating" do
    item = Item.new(name: " name ", brand: " brand ", size: " 12v", model: "123 ",
                    serial: " a bc", strength: " heavy")

    item.valid?

    assert_equal "name", item.name
    assert_equal "brand", item.brand
    assert_equal "12v", item.size
    assert_equal "123", item.model
    assert_equal "a bc", item.serial
    assert_equal "heavy", item.strength
  end
end
