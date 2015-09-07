class SubscriptionService

  # def self.create(subscription:, actor:)
  #   actor.ability.authorize! :create, subscription
  #   subscription.tap(&:save!)
  # end

  def self.update(subscription:, params:, actor:)
    actor.ability.authorize! :choose_subscription_plan, subscription.group

    case params[:kind].try(:to_sym)
    when :paid
      return unless params[:creator_id].to_i == actor.id && json = ChargifyService.new(params[:subscription_id]).fetch!
      subscription.update kind:                     params[:kind],
                          chargify_subscription_id: params[:subscription_id],
                          plan:                     json['product']['handle'],
                          trial_ended_at:           json['activated_at'],
                          activated_at:             json['activated_at'],
                          expires_at:               json['expires_at']
    when :gift
      subscription.update kind:                     params[:kind],
                          trial_ended_at:           Time.zone.now,
                          activated_at:             Time.zone.now
    end
    subscription
  end

end
