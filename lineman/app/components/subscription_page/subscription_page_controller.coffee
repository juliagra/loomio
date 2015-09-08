angular.module('loomioApp').controller 'SubscriptionPageController', ($rootScope, $routeParams, Records, AppConfig) ->
  $rootScope.$broadcast('currentComponent', { page: 'subscriptionPage'})

  @init = (group) =>
    if group and !@group?
      @group      = group
      Records.memberships.fetchByGroup(@group.key, per: 100)

  @init Records.discussions.find $routeParams.key
  Records.groups.findOrFetchById($routeParams.key).then @init, (error) ->
    $rootScope.$broadcast('pageError', error, group)

  @groupPlan = ->
    if @group.subscriptionKind == 'paid'
      switch @group.subscriptionPlan
        when AppConfig.chargify.plans.standard.name then 'standard'
        when AppConfig.chargfiy.plans.premium.name then 'premium'
    else
      @group.subscriptionKind

  return
