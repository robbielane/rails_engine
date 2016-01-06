class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  def self.most_revenue(limit)
    all.sort_by(&:top_revenue)
       .reverse[0...limit.to_i]
  end

  def top_revenue
    invoices.success
            .joins(:invoice_items)
            .sum('quantity * unit_price')
  end

  def revenue_by(date)
    invoices.where(created_at: date)
            .success
            .joins(:invoice_items)
            .sum('quantity * unit_price')
  end

  def revenue(params)
    if params[:date]
      { revenue: revenue_by(params[:date]).to_s }
    else
      { revenue: top_revenue.to_s }
    end
  end

  def favorite_customer
    Customer.joins(:invoices)
            .joins(:transactions)
            .where("invoices.merchant_id = ? AND transactions.result = 'success'", id)
            .group('id')
            .order('count(invoices.customer_id) DESC')
            .first
  end

  def customers_with_pending_invoices
    Customer.joins(:invoices)
            .joins('INNER JOIN transactions ON transactions.invoice_id = invoices.id')
            .where("invoices.merchant_id = ? AND transactions.result = 'failed'", self.id)
            .distinct
  end

end
