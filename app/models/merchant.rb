class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def self.most_revenue(limit)
    all.sort_by(&:top_revenue).reverse[0...limit.to_i]
  end

  def top_revenue
    invoices.success.joins(:invoice_items).sum('quantity * unit_price')
  end

  def revenue
    { revenue: top_revenue.to_s }
  end
end
