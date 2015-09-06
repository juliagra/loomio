class SubscriptionsController < ApplicationController
  def signup_success
    @subscription = SubscriptionService.update(subscription: subscription_from_ref, params: subscription_params, actor: current_user)
    redirect_to @subscription.group, started_paid_subscription: true
  end

  def webhook
  end

  private

  def subscription_from_ref
    return unless params[:ref] && group_id = param_from_ref[1]
    @subscription_from_ref ||= Group.find_by(id: group_id).try(:subscription)
  end

  def subscription_params
    {
      kind: :paid,
      subscription_id: params[:id],
      creator_id: param_from_ref[0]
    }
  end

  def param_from_ref(index)
    params[:ref].split(',')[index].split(':')[1]
  end
end
