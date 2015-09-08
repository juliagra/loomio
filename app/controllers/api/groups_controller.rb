class API::GroupsController < API::RestfulController
  load_and_authorize_resource only: :show, find_by: :key
  load_resource only: [:upload_photo, :use_gift_subscription, :change_subscription], find_by: :key

  def archive
    load_resource
    GroupService.archive(group: @group, actor: current_user)
    respond_with_resource
  end

  def subgroups
    load_and_authorize :group
    @groups = @group.subgroups.select{|g| can? :show, g }
    respond_with_collection
  end

  def use_gift_subscription
    subscription_service.start_gift!
    respond_with_resource
  end

  def change_subscription
    if params[:plan].try(:to_sym) == :gift
      subscription_service.end_subscription!
    else
      subscription_service.change_plan! params[:plan]
    end
    respond_with_resource
  end

  def upload_photo
    ensure_photo_params
    service.update group: resource, actor: current_user, params: { params[:kind] => params[:file] }
    respond_with_resource
  end

  private

  def subscription_service
    @service ||= SubscriptionService.new(resource, current_user)
  end

  def ensure_photo_params
    params.require(:file)
    raise ActionController::UnpermittedParameters.new([:kind]) unless ['logo', 'cover_photo'].include? params.require(:kind)
  end

end
