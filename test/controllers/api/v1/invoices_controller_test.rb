require 'test_helper'

class Api::V1::InvoicesControllerTest < ActionController::TestCase

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

    json_response.each do |invoice|
      assert invoice['id']
      assert invoice['customer_id']
      assert invoice['merchant_id']
      assert invoice['status']
      assert invoice['created_at']
      assert invoice['updated_at']
    end
  end

  test "#show returns a single record" do
    get :show, format: :json, id: Invoice.first.id

    assert_kind_of Hash, json_response
  end

  test "#show returns the correct record" do
    invoice = Invoice.create!(status: "shipped")
    get :show, format: :json, id: invoice.id

    assert_equal invoice.status, json_response['status']
  end

  test "#find by status returns the expected record" do
    invoice = Invoice.create!(status: "shipped")
    get :find, format: :json, status: 'shipped'

    assert_equal invoice.status, json_response['status']
  end

  test "#find_all returns an array of records" do
    Invoice.create!(status: "shipped")
    Invoice.create!(status: "shipped")
    get :find_all, format: :json, status: 'shipped'

    assert_equal 2, json_response.count
  end

  test "#transactions returns associated records" do
    invoice = Invoice.create!(status: "shipped")
    transaction = invoice.transactions.create!(credit_card_number: "4242424242424242")
    get :transactions, format: :json, id: invoice.id

    assert_equal 1, json_response.count
    assert_equal transaction.credit_card_number, json_response.first['credit_card_number']
  end

  test "#invoice_items returns associated records" do
    invoice = Invoice.create!(status: "shipped")
    invoice_item = invoice.invoice_items.create!(quantity: 3, unit_price: 34242)
    get :invoice_items, format: :json, id: invoice.id

    assert_equal 1, json_response.count
    assert_equal invoice_item.quantity, json_response.first['quantity']
  end

  test "#items returns associated records" do
    invoice = Invoice.create!(status: "shipped")
    item = Item.create!(name: "Item Name", unit_price: 34242)
    invoice_item = invoice.invoice_items.create!(quantity: 3, item_id: item.id, unit_price: 34242)
    get :items, format: :json, id: invoice.id

    assert_equal 1, json_response.count
    assert_equal item.name, json_response.first['name']
  end

  test "#merchant returns associated record" do
    merchant = Merchant.create!(name: 'Merchant Name')
    invoice = merchant.invoices.create!(status: "shipped")
    get :merchant, format: :json, id: invoice.id

    assert_equal merchant.name, json_response['name']
  end

  test "#customer returns associated record" do
    customer = Customer.create!(first_name: 'Robbie')
    invoice = customer.invoices.create!(status: "shipped")
    get :customer, format: :json, id: invoice.id

    assert_equal customer.first_name, json_response['first_name']
  end
end
