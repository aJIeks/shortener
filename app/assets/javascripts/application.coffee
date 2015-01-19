#= require jquery
#= require vendor/bootstrap/bootstrap.min
#= require vendor/angular/angular.min
#= require vendor/angular/angular-route.min
#= require vendor/ng-storage.min
#= require vendor/oauth-ng
#= require_self
#= require_directory .

"use strict"

# Declare app level module which depends on filters, and services
deps = ['oauth', "shortener.controllers", "ngRoute", 'ui.bootstrap']

app = angular.module("shortener", deps).config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when "/",
    templateUrl: "/links/index.html"
    controller: "WelcomeCtrl"

  $routeProvider.otherwise redirectTo: "/"

  $locationProvider.html5Mode(true).hashPrefix('!')
]
