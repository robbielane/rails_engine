require 'test_helper'

class Api::V1::ItemsControllerTest < ActionController::TestCase

  test "#index responds to json" do
    get :index, format: :json

    assert_response :success
  end

  test "#index returns an array of records" do
    get :index, format: :json

    assert_kind_of Array, json_response
  end

  test "#index contains correct attributes" do
    get :index, format: :json

    json_response.each do |item|
      assert item['id']
      assert item['name']
      assert item['description']
      assert item['unit_price']
      assert item['created_at']
      assert item['updated_at']
    end
  end

  test "#show returns a single record" do
    get :show, format: :json, id: Item.first.id

    assert_kind_of Hash, json_response
  end

  test "#show returns the correct record" do
    item = Item.create!(name: "Item Name", unit_price: 29999)
    get :show, format: :json, id: item.id

    assert_equal item.name, json_response['name']
  end

  test "#find by name returns the expected record" do
    item = Item.create!(name: "Item Name", unit_price: 30404)
    get :find, format: :json, name: 'Item Name'

    assert_equal item.name, json_response['name']
  end

  test "#find_all returns an array of records" do
    Item.create!(name: "Item Name", unit_price: 30404)
    Item.create!(name: "Item Name", unit_price: 30404)
    get :find_all, format: :json, name: 'Item Name'

    assert_equal 2, json_response.count
  end

  test "#invoice_items returns associated records" do
    item = Item.create!(name: "Item Name", unit_price: 30404)
    invoice_item1 = item.invoice_items.create!(quantity: 3, unit_price: 4303)
    invoice_item2 = item.invoice_items.create!(quantity: 2, unit_price: 6333)
    get :invoice_items, format: :json, id: item.id

    assert_equal 2, json_response.count
    assert_equal invoice_item1.quantity, json_response.first['quantity']
  end

  test "#merchant returns associated record" do
    merchant = Merchant.create!(name: 'Merchant Name')
    item = merchant.items.create!(name: "Item Name", unit_price: 30404)
    get :merchant, format: :json, id: item.id

    assert_equal merchant.name, json_response['name']
  end
end
