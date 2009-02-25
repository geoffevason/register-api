require 'hpricot'

require File.join(File.dirname(__FILE__), 'config')
require File.join(File.dirname(__FILE__), 'register_api')

module Register
  
  def self.logger() RAILS_DEFAULT_LOGGER; end
  
  def self.log!(msg)
    logger.info "[Register API] #{msg}"
  end
  
  def self.error!(msg)
    logger.info "[Register API ERROR] #{msg}"
  end
  
  class UnknownError < StandardError; end
  class RegisterApiError < StandardError; end
  
  class Account
    attr_accessor :success, :id, :uid, :pw, :party_id, :full_response, :s_login_pass
    def initialize
      success = false
    end
    
    def insert_new_order(options)
      doc = Api::InsertNewOrder(account_options.merge(options))
      purchase = Register::Purchase.new()
      purchase.full_response = doc.to_s
      purchase.id = (doc/'OrderID').inner_text  
      if purchase.id.blank?
        raise RegisterApiError, "No Order ID Created"
      end
      return purchase
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
    
    def account_options
      {:UID => uid, :PW => pw}
    end
    
    def empty_cart(options={})
      doc = Api::DeleteFromCart(account_options.merge(options.merge({:EmptyCart=>'On'})))
      return doc
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
  
    def cart_item_count(options = {})
      doc = Api::GetCartContent(account_options.merge(options))
      res = 0
      items = doc.search('//item')
      res = items.length
      return res
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
  
    def add_to_cart(options)
      doc = Api::AddToCart(account_options.merge(options))        
      return doc
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
  
    def preconfigure(options)
      doc = Api::Preconfigure(account_options.merge(options))        
      return doc
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
    
    def update_account_info(options)
      # We don't merge accont optionns here because UID & PW need to be from the super account.
      update_options = {:NewUID => uid, :NewPW => pw, :ConfirmNewPW => pw}
      doc = Api::UpdateAccountInfo(update_options.merge(options))
    
      account = Register::Account.new()
    
      el = (doc/'NewAccount')
      if el && (el/'StatusCustomerInfo').inner_text == "Successful"
        success = true
        #uid = options["NewUID"]
        #pw = options["NewPW"]
        id = (el/'Account').inner_text
        party_id = (el/'PartyID').inner_text
        s_login_pass = (el/'sLoginPass').inner_text
      end  
      doc.search("CCNumber").remove
      full_response = doc.to_s
    
      return true
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
    
  end
  
  class Purchase
    attr_accessor :id, :full_response
  end
    
  def self.domain_available?(options)
    begin
      doc = Api::Check(options)
      if (doc/'RRPCode').inner_text == "210"
        return true
      else
        return false
      end
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
  end
  
  def self.alternative_domains(options) 
    begin
      doc = Api::NameSpinner(options.merge(:SensitiveContent => "True", :UseHyphens => "True"))
      res = []
      (doc/'namespin domains domain').each do |domain|
        for tld in ['com', 'net']
          if domain.attributes[tld] && domain.attributes[tld].to_s == 'y'.to_s
            res << "#{domain.attributes['name']}.#{tld}"
          end
        end
      end
      return res
    rescue RegisterApiError => e
      raise RegisterApiError, "#{e}"
    rescue
      raise UnknownError, "Unknown error for Register.com API"
    end
  end
  
  def self.create_account(options)
    doc = Api::CreateAccount(options) 
    account = Register::Account.new()
    
    el = (doc/'NewAccount')
    if el && (el/'StatusCustomerInfo').inner_text == "Successful"
      account.success = true
      account.uid = options[:NewUID]
      account.pw = options[:NewPW]
      account.id = (el/'Account').inner_text
      account.party_id = (el/'PartyID').inner_text
      account.s_login_pass = (el/'sLoginPass').inner_text
    end  
    doc.search("CCNumber").remove
    account.full_response = doc.to_s
    
    return account
  rescue RegisterApiError => e
    raise RegisterApiError, "#{e}"
  rescue
    raise UnknownError, "Unknown error for Register.com API"
  end  
  
end
