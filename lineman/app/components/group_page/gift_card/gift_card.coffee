angular.module('loomioApp').directive 'giftCard', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/group_page/gift_card/gift_card.html'
  replace: true
  controller: ($scope) ->
