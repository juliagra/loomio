class ChargifyService

  def self.available?
    ENV['CHARGIFY_APP_NAME'].present? && ENV['CHARGIFY_API_KEY'].present?
  end

  def initialize(subscription_id)
    @subscription_id = subscription_id
  end

  def fetch!
    response = JSON.parse HTTParty.get(chargify_api_endpoint, basic_auth: basic_auth).body
    response['subscription'] if response.present?
  end

  def cancel!
    response = JSON.parse HTTParty.delete(chargify_api_endpoint, basic_auth: basic_auth).body
    response['subscription'] if response.present?
  end

  def change_plan!(product_handle)
    response = JSON.parse HTTParty.put(chargify_api_endpoint, body: { subscription: { product_handle: product_handle } }, basic_auth: basic_auth).body
    response['subscription'] if response.present?
  end

  private

  def chargify_api_endpoint
    "http://#{ENV['CHARGIFY_APP_NAME']}.chargify.com/subscriptions/#{@subscription_id}.json"
  end

  def basic_auth
    {
      username: ENV['CHARGIFY_API_KEY'],
      password: :x # that's Mister X to you
    }
  end
end
