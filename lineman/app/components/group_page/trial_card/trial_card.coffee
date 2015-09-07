angular.module('loomioApp').directive 'trialCard', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/group_page/trial_card/trial_card.html'
  replace: true
  controller: ($scope, ModalService, ChoosePlanModal) ->

    $scope.showCard = ->
      _.includes ['gift', 'trial'], $scope.group.subscriptionKind

    $scope.isExpired = ->
      if moment().isAfter($scope.group.subscriptionExpiresAt)
        true
      else
        false

    $scope.choosePlan = ->
      ModalService.open ChoosePlanModal, group: -> $scope.group
