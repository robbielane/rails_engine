# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


require 'csv'

namespace :load_data do
  task :all => :environment do

    merchants = '../rails_engine_data/merchants.csv'
    CSV.foreach(merchants, headers: true) do |row|
      merchant = Merchant.create!(row.to_hash)
      puts "added merchant ##{merchant.id}: #{merchant.name}"
    end

    customers = '../rails_engine_data/customers.csv'
    CSV.foreach(customers, headers: true) do |row|
      customer = Customer.create!(row.to_hash)
      puts "added customer ##{customer.id}: #{customer.first_name} #{customer.last_name}"
    end

    items = '../rails_engine_data/items.csv'
    CSV.foreach(items, headers: true) do |row|
      item = Item.create!(row.to_hash)
      puts "added item ##{item.id}: #{item.name} for Merchant: #{item.merchant.name}"
    end

    invoices = '../rails_engine_data/invoices.csv'
    CSV.foreach(invoices, headers: true) do |row|
      invoice = Invoice.create!(row.to_hash)
      puts "added invoice ##{invoice.id}"
    end

    invoice_items = '../rails_engine_data/invoice_items.csv'
    CSV.foreach(invoice_items, headers: true) do |row|
      invoice_item = InvoiceItem.create!(row.to_hash)
      puts "added invoice item ##{invoice_item.id}"
    end

    transactions = '../rails_engine_data/transactions.csv'
    CSV.foreach(transactions, headers: true) do |row|
      transaction = Transaction.create!(row.to_hash)
      puts "added transaction ##{transaction.id}"
    end
  end
end