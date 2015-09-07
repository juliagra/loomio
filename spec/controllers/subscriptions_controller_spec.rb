require 'rails_helper'

describe SubscriptionsController do

  let(:user) { create :user }
  let(:group) { create :group }

  before do
    group.admins << user
    sign_in user
  end

  describe 'signup_success' do

    context 'success' do
      it 'updates the group subscription plan to paid' do
        get :signup_success, ref: "userId:#{user.id},groupId:#{group.id}"
        expect(group.reload.subscription.kind).to eq 'paid'
        expect(response).to redirect_to group_url(group)
      end
    end

    context 'failure' do
      it 'does not update the group subscription plan when creator does not match' do
        get :signup_success, id: 100, ref: "userId:notAUserId,groupId:#{group.id}"
        expect(group.reload.subscription.kind).to_not eq 'paid'
        expect(response).to redirect_to dashboard_url
      end

      it 'does not update the group subscription plan when group id does not match' do
        expect { get :signup_success, id: 100, ref: "userId:#{user.id},groupId:notagroupId" }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'does not update the group subscription plan when no subscription is not found in chargify' do
        stub_request(:get, /loomio-test.chargify.com/).
            with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
            to_return(status: 404, body: '', headers: {})
        get :signup_success, id: 100, ref: "userId:#{user.id},groupId:#{group.id}"
        expect(group.reload.subscription.kind).to_not eq 'paid'
        expect(response).to redirect_to dashboard_url
      end
    end

  end

end
