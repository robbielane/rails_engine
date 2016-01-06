class Api::V1::MerchantsController < Api::V1::BaseController

  def index
    respond_with Merchant.all
  end

  def show
    respond_with Merchant.find(params[:id])
  end

  def find
    respond_with Merchant.find_by(merchant_params)
  end

  def find_all
    respond_with Merchant.where(merchant_params)
  end

  def random
    respond_with Merchant.order('RANDOM()').first
  end

  def items
    respond_with Merchant.find(params[:id]).items
  end

  def invoices
    respond_with Merchant.find(params[:id]).invoices
  end

  def most_revenue
    respond_with Merchant.most_revenue(params[:quantity])
  end

  def revenue
    respond_with Merchant.find(params[:id]).revenue(merchant_params)
  end

  def favorite_customer
    respond_with Merchant.find(params[:id]).favorite_customer
  end

  private

  def merchant_params
    params.permit(:name, :id, :updated_at, :created_at, :date)
  end
end
