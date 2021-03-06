class InvoiceItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :invoice

  before_save :convert_to_dollars

  scope :success, -> { joins(:invoice).merge(Invoice.success) }

  def convert_to_dollars
    self.unit_price =  self.unit_price / 100.00
  end

end
