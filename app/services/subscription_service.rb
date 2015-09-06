class SubscriptionService

  def self.create(subscription:, actor:)
    actor.ability.authorize! :create, subscription
    subscription.tap(&:save!)
  end

  def self.update(subscription:, params:, actor)
    actor.ability.authorize! :update, subscription
    subscription.update params
    subscription
  end

end
