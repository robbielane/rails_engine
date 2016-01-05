require 'test_helper'

class Api::V1::MerchantsControllerTest < ActionController::TestCase

  test "#index responds to json" do
    get :index, format: :json

    assert_response :success
  end

  test "#index returns an array of records" do
    get :index, format: :json

    assert_kind_of Array, json_response
  end

  test "#index contains the correct properties" do
    get :index, format: :json

    json_response.each do |merchant|
      assert merchant['name']
      assert merchant['created_at']
      assert merchant['updated_at']
    end
  end

  test "#show responds to json" do
    get :show, format: :json, id: Merchant.first.id

    assert_response :success
  end

  test "#show returns correct data" do
    merchant = Merchant.create!(name: "Merchant Name")
    get :show, format: :json, id: merchant.id

    assert_equal merchant[:name], json_response['name']
  end

  test "#find by name returns the expected record" do
    merchant = Merchant.create!(name: "Merchant Name")
    get :find, format: :json, name: 'Merchant Name'

    assert_equal merchant.name, json_response['name']
  end

  test "#find_all returns an array of records" do
    Merchant.create!(name: "Merchant Name")
    Merchant.create!(name: "Merchant Name")
    get :find_all, format: :json, name: 'Merchant Name'

    assert_equal 2, json_response.count
  end

  test "#invoices returns associated records" do
    merchant = Merchant.create!(name: "Merchant Name")
    invoice = merchant.invoices.create!(status: 'shipped')
    get :invoices, format: :json, id: merchant.id

    assert_equal 1, json_response.count
    assert_equal invoice.status, json_response.first['status']
  end

  test "#items returns associated records" do
    merchant = Merchant.create!(name: "Merchant Name")
    item = merchant.items.create!(name: 'Item Name', unit_price: '29999')
    get :items, format: :json, id: merchant.id

    assert_equal 1, json_response.count
    assert_equal item.name, json_response.first['name']
  end
end
