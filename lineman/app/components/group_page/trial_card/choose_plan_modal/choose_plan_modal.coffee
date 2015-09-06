angular.module('loomioApp').factory 'ChoosePlanModal', ->
  templateUrl: 'generated/components/group_page/trial_card/choose_plan_modal/choose_plan_modal.html'
  size: 'choose-plan-modal'
  controller: ($scope, group, ModalService, ConfirmGiftPlanModal, CurrentUser, $window) ->
    $scope.group = group

    $scope.chooseGiftPlan = ->
      ModalService.open ConfirmGiftPlanModal, group: -> $scope.group

    $scope.choosePaidPlan = (kind) ->
      host = "https://loomio-test.chargify.com/"
      path = switch kind
        when 'standard' then "subscribe/s8kb52jmj52m/test-standard-plan"
        when 'plus'     then "subscribe/m8zrsfx77p29/test-premium-plan"

      $window.location = "#{host}#{path}?#{encodedChargifyParams()}"

    encodedChargifyParams = ->
      params =
        first_name: CurrentUser.firstName()
        last_name: CurrentUser.lastName()
        email: CurrentUser.email
        organization: $scope.group.name
        reference: "userId:#{CurrentUser.id},groupId:#{$scope.group.id}"

      _.map(_.keys(params), (key) ->
        encodeURIComponent(key) + "=" + encodeURIComponent(params[key])
      ).join('&')
