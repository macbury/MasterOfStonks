class ExchangeWith < Service
  def initialize(money, currency = MoneyRails.default_currency)
    @money = money
    @currency = currency
  end

  def call
    check_rates!
    eu_bank.exchange_with(money, currency)
  end

  private

  attr_reader :money, :currency

  def check_rates!
    if eu_bank.rates_updated_at.nil? || eu_bank.rates_updated_at < 1.day.ago
      eu_bank.save_rates(cache)
      eu_bank.update_rates(cache)
    end    
  end

  def cache
    Rails.root.join('tmp/rates.xml')
  end

  def eu_bank
    Money.default_bank
  end
end