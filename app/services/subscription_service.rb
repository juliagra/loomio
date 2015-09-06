class SubscriptionService

  def self.create(subscription:, actor:)
    actor.ability.authorize! :create, subscription
    subscription.tap(&:save!)
  end

  def self.update(subscription:, params:, actor:)
    actor.ability.authorize! :choose_subscription_plan, subscription.group
    return unless params[:creator_id].to_i == actor.id &&
                  subscription_json = ChargifyService.new(params[:subscription_id]).fetch!(chargify_subscription_fields)

    subscription.update kind: :paid,
                        chargify_subscription_id: params[:subscription_id],
                        plan:                     subscription_json['product']['handle'],
                        trial_ended_at:           subscription_json['trial_ended_at'],
                        activated_at:             subscription_json['activated_at'],
                        expires_at:               subscription_json['expires_at']
    subscription
  end

  private

  def self.chargify_subscription_fields
    [:expires_at, :trial_ended_at, :activated_at]
  end

end
