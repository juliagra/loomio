class ChargifyService

  def initialize(subscription_id)
    @subscription_id = subscription_id
  end

  def fetch!
    response = JSON.parse HTTParty.get(chargify_fetch_url, basic_auth: basic_auth).body
    response['subscription'] if response.present?
  end

  private

  def chargify_fetch_url
    "https://loomio-test.chargify.com/subscriptions/#{@subscription_id}.json"
  end

  def basic_auth
    {
      username: ENV['CHARGIFY_API_KEY'],
      password: :x # that's Mister X to you
    }
  end
end
