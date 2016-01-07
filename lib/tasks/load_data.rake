require 'csv'

namespace :load_data do
  task :all => :environment do

    merchants = 'data/merchants.csv'
    CSV.foreach(merchants, headers: true) do |row|
      merchant = Merchant.create!(row.to_hash)
      puts "added merchant ##{merchant.id}: #{merchant.name}"
    end

    customers = 'data/customers.csv'
    CSV.foreach(customers, headers: true) do |row|
      customer = Customer.create!(row.to_hash)
      puts "added customer ##{customer.id}: #{customer.first_name} #{customer.last_name}"
    end

    items = 'data/items.csv'
    CSV.foreach(items, headers: true) do |row|
      item = Item.create!(row.to_hash)
      puts "added item ##{item.id}: #{item.name} for Merchant: #{item.merchant.name}"
    end

    invoices = 'data/invoices.csv'
    CSV.foreach(invoices, headers: true) do |row|
      invoice = Invoice.create!(row.to_hash)
      puts "added invoice ##{invoice.id}"
    end

    invoice_items = 'data/invoice_items.csv'
    CSV.foreach(invoice_items, headers: true) do |row|
      invoice_item = InvoiceItem.create!(row.to_hash)
      puts "added invoice item ##{invoice_item.id}"
    end

    transactions = 'data/transactions.csv'
    CSV.foreach(transactions, headers: true) do |row|
      transaction = Transaction.create!(
                                        invoice_id: row.to_hash['invoice_id'],
                                        credit_card_number: row.to_hash['credit_card_number'],
                                        result: row.to_hash['result'],
                                        created_at: row.to_hash['created_at'],
                                        updated_at: row.to_hash['updated_at']
                                       )
      puts "added transaction ##{transaction.id}"
    end
  end
end
