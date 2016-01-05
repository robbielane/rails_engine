class Api::V1::ItemsController < Api::V1::BaseController
  def index
    respond_with Item.all
  end

  def show
    respond_with Item.find(params[:id])
  end

  def find
    respond_with Item.find_by(item_params)
  end

  def find_all
    respond_with Item.where(item_params)
  end

  def random
    respond_with Item.order('RANDOM()').first
  end

  def invoice_items
    respond_with Item.find(params[:id]).invoice_items
  end

  private

  def item_params
    params.permit(
      :id,
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :updated_at,
      :created_at
    )
  end
end
