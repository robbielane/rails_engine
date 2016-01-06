class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :transactions, through: :invoices

  def favorite_merchant
    Merchant.joins(:invoices)
            .where('invoices.customer_id = ?', self.id)
            .group('id')
            .order('count(invoices.merchant_id) DESC')
            .first
  end
end
