class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  before_save :convert_to_dollars

  default_scope { order('id ASC') }

  def convert_to_dollars
    self.unit_price =  self.unit_price / 100.00
  end

  def self.most_revenue(limit)
    all.sort_by(&:total_revenue)
       .reverse[0...limit.to_i]
  end

  def self.most_items(limit)
    all.sort_by(&:total_sold)
       .reverse[0...limit.to_i]
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def total_sold
    invoice_items.sum('quantity')
  end

  def best_day
    { best_day: invoice_items.success.group("invoices.created_at").order("sum_quantity DESC").sum("quantity").first[0] }
  end
end
