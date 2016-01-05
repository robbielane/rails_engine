require 'test_helper'

class Api::V1::InvoiceItemsControllerTest < ActionController::TestCase

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

    json_response.each do |invoice_item|
      assert invoice_item['id']
      assert invoice_item['invoice_id']
      assert invoice_item['item_id']
      assert invoice_item['quantity']
      assert invoice_item['unit_price']
      assert invoice_item['created_at']
      assert invoice_item['updated_at']
    end
  end

  test "#show returns a single record" do
    get :show, format: :json, id: InvoiceItem.first.id

    assert_kind_of Hash, json_response
  end

  test "#show returns the correct record" do
    invoice_item = InvoiceItem.create!(quantity: 3, unit_price: 30303)
    get :show, format: :json, id: invoice_item.id

    assert_equal invoice_item.quantity, json_response['quantity']
  end

  test "#find by status returns the expected record" do
    invoice_item = InvoiceItem.create!(quantity: 3, unit_price: 30303)
    get :find, format: :json, quantity: 3

    assert_equal invoice_item.quantity, json_response['quantity']
  end

  test "#find_all returns an array of records" do
    InvoiceItem.create!(quantity: 3, unit_price: 30303)
    InvoiceItem.create!(quantity: 3, unit_price: 30303)
    get :find_all, format: :json, quantity: 3

    assert_equal 2, json_response.count
  end

  test "#invoice returns associated record" do
    invoice = Invoice.create!(status: 'shipped')
    invoice_item = invoice.invoice_items.create!(quantity: 3, unit_price: 30303)
    get :invoice, format: :json, id: invoice_item.id

    assert_equal invoice.status, json_response['status']
  end

  test "#item returns associated record" do
    item = Item.create!(name: 'Item Name', unit_price: 30303)
    invoice_item = item.invoice_items.create!(quantity: 3, unit_price: 30303)
    get :item, format: :json, id: invoice_item.id

    assert_equal item.name, json_response['name']
  end
end
