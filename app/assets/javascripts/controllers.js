// Controllers

(function() {
    angular.module("shortener.controllers", [])
      .controller("WelcomeCtrl",  ['$scope', '$http', '$timeout', 'AccessToken', 'Profile', function($scope, $http, $timeout, AccessToken, Profile) {
            $scope.form_class = ''
            $scope.logged = false
            $scope.links = []
            $scope.alerts = []
            $scope.panel_class = 'in-center'

            $scope.profile = Profile.get

            $timeout(function() {
                $scope.logged = !!AccessToken.token
            }, 0)

            $scope.$watch('logged', function(new_value){
                $scope.form_class = new_value ? 'has-key' : ''

                if(new_value)
                {
                    $http.get('/api/v1/links?my&token=' + AccessToken.token.access_token).success(function(data, status, headers, config){
                        for(i = 0; i < data.length; i++)
                        {
                            $http.get(data[i].url).success(function(data){
                                $scope.links.push(data)
                                $scope.panel_class = 'container'
                            })
                        }
                    })
                }
            })

            $scope.$on('oauth:login', function(event, token) {
                $scope.logged = true

            });

            $scope.$on('oauth:logout', function(event) {
                $scope.logged = false
            });

            $scope.$on('oauth:loggedOut', function(event) {
                $scope.logged = false
            });

            $scope.$on('oauth:denied', function(event) {
                $scope.logged = false
            });

            $scope.$on('oauth:expired', function(event) {
                $scope.logged = false
            });

            $scope.closeAlert = function(index) {
                $scope.alerts.splice(index, 1);
            };

            $scope.send = function() {
                if($scope.url == '')
                    return;
                $http.post('/api/v1/links', { link: {url: $scope.url, key: $scope.key }, token: AccessToken.token }).
                    success(function(data, status, headers, config) {
                        $scope.links.push(data)
                        $scope.panel_class = 'container'
                    }).
                    error(function(data, status, headers, config) {
                        angular.forEach(data.message, function(msg)
                        {
                            $scope.alerts.push({type: 'warning', msg: msg})
                        });

                    });
            }
    }])
}).call(this);
