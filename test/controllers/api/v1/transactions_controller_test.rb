require 'test_helper'

class Api::V1::TransactionsControllerTest < ActionController::TestCase

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

    json_response.each do |transaction|
      assert transaction['invoice_id']
      assert transaction['credit_card_number']
      assert transaction['result']
      assert transaction['created_at']
      assert transaction['updated_at']
    end
  end

  test "#show responds to json" do
    get :show, format: :json, id: Transaction.first.id

    assert_response :success
  end

  test "#show returns correct data" do
    transaction = Transaction.create!(result: "success")
    get :show, format: :json, id: transaction.id

    assert_equal transaction[:result], json_response['result']
  end

  test "#find by status returns the expected record" do
    transaction = Transaction.create!(result: 'success')
    get :find, format: :json, result: 'success'

    assert_equal transaction.result, json_response['result']
  end

  test "#find_all returns an array of records" do
    Transaction.create!(result: 'success')
    Transaction.create!(result: 'success')
    get :find_all, format: :json, result: 'success'

    assert_equal 2, json_response.count
  end

  test "#invoice returns associated record" do
    invoice = Invoice.create!(status: 'shipped')
    transaction = invoice.transactions.create!(result: 'success')

    get :invoice, format: :json, id: transaction.id

    assert_equal invoice.status, json_response['status']
  end

end
