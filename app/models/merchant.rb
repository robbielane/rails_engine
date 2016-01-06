class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def self.most_revenue(limit)
    invoices
  end

  def revenue
    self.invoices.success.joins(:invoice_items).sum('quantity * unit_price')
  end
end
