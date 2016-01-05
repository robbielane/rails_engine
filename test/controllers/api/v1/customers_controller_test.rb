require 'test_helper'

class Api::V1::CustomersControllerTest < ActionController::TestCase

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
      assert item['first_name']
      assert item['last_name']
      assert item['created_at']
      assert item['updated_at']
    end
  end

  test "#show returns a single record" do
    get :show, format: :json, id: Item.first.id

    assert_kind_of Hash, json_response
  end

  test "#show returns the correct record" do
    customer = Customer.create!(first_name: "Robbie", last_name: 'Lane')
    get :show, format: :json, id: customer.id

    assert_equal customer.first_name, json_response['first_name']
  end

  test "#find by name returns the expected record" do
    customer = Customer.create!(first_name: "Robbie", last_name: 'Lane')
    get :find, format: :json, first_name: 'Robbie'

    assert_equal customer.first_name, json_response['first_name']
  end

  test "#find_all returns an array of records" do
    Customer.create!(first_name: "Robbie")
    Customer.create!(first_name: "Robbie")
    get :find_all, format: :json, first_name: 'Robbie'

    assert_equal 2, json_response.count
  end

  test "#invoices returns associated records" do
    customer = Customer.create!(first_name: "Robbie", last_name: 'Lane')
    invoice1 = customer.invoices.create!(status: 'shipped')
    invoice2 = customer.invoices.create!(status: 'shipped')
    get :invoices, format: :json, id: customer.id

    assert_equal 2, json_response.count
    assert_equal invoice1.status, json_response.first['status']
  end

  test "#transactions returns associated records" do
    customer = Customer.create!(first_name: "Robbie", last_name: 'Lane')
    invoice = customer.invoices.create!(status: 'shipped')
    transaction = invoice.transactions.create!(credit_card_number: '4242424242424242')
    get :invoices, format: :json, id: customer.id

    assert_equal 1, json_response.count
    assert_equal invoice.status, json_response.first['status']
  end

end
