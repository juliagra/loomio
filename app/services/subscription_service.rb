class SubscriptionService


  def self.create(subscription:, actor:)
    actor.ability.authorize! :create, subscription
    subscription.tap(&:save!)
  end

end
