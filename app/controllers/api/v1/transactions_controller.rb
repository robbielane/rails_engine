class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find(params[:id])
  end

  def find
    respond_with Transaction.find_by(transaction_params)
  end

  def find_all
    respond_with Transaction.where(transaction_params)
  end

  def random
    respond_with Transaction.order('RANDOM()').first
  end

  def invoice
    respond_with Transaction.find(params[:id]).invoice
  end

  private

  def transaction_params
    params.permit(
      :id,
      :invoice_id,
      :credit_card_number,
      :result,
      :updated_at,
      :created_at
    )
  end
end
