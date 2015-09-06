class SubscriptionsController < ApplicationController
  def signup_success
    @subscription = SubscriptionService.update(subscription: subscription_from_ref, params: subscription_params, actor: current_user)
    redirect_to @subscription.group, started_paid_subscription: true
  end

  def webhook
  end

  private

  def subscription_from_ref
    return unless params[:ref] && group_id = params[:ref].split(',')[1].split(':')[1]
    @subscription_from_ref ||= Group.find_by(id: group_id).try(:subscription)
  end

  def subscription_params
    {
      kind: :paid,
      subscription_id: params[:id],
      creator_id: params[:ref].split(',')[0].split(':')[1]
    }
  end
end
