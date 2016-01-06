class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def self.most_revenue(limit)
    all.sort_by(&:revenue).limit(limit)
  end

  def revenue
    { revenue: self.invoices.success.joins(:invoice_items).sum('quantity * unit_price').to_s }
  end
end
