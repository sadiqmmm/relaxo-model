
require 'relaxo/model'

class Invoice
	class Transaction; end
	
	include Relaxo::Model
	
	property :id, UUID
	property :number
	property :name
	
	property :date, Attribute[Date]
	
	view :all, [:type], index: [:id]
	
	def transactions
		Invoice::Transaction.by_invoice(@dataset, invoice: self)
	end
end

class Invoice::Transaction
	include Relaxo::Model
	
	parent_type Invoice
	
	property :id, UUID
	property :invoice, BelongsTo[Invoice]
	property :date, Attribute[Date]
	
	view :all, [:type], index: [:id]
	
	view :by_invoice, [:type, 'by_invoice', :invoice], index: [[:date, :id]]
end

class User
	include Relaxo::Model
	
	property :email, Attribute[String]
	property :name
	property :intro
	
	view :all, [:type], index: [:email]
	
	view :by_name, [:type, 'by_name'], index: [:name]
end

RSpec.shared_context "model" do
	let(:database_path) {File.join(__dir__, 'test')}
	let(:database) {Relaxo.connect(database_path)}
	
	let(:document_path) {'test/document.json'}
	
	before(:each) {FileUtils.rm_rf(database_path)}
end