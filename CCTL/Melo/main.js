var app = angular.module("melo", ['angular.filter']);

app.controller('MainController', function ($scope, $http, $interval) {

    $scope.currentMerchant = null;
    $scope.rowNumber = 20;
    var user = JSON.parse(sessionStorage.getItem('cko.user'));

    $scope.$watch('search', function () {
        getMerchants();
    });

    function getMerchants() {
        $scope.merchants = null;
        if (typeof $scope.search === "undefined" || !$scope.search) return
        $http({ 
            method: 'GET', 
            url: 'http://localhost/melo.api/merchant?searchValue=' + $scope.search,
            headers: {
                'x-auth-token': user.token
            }
        })
            .then(function successCallback(response) {
                if (response.data != '')
                    $scope.merchants = response.data;
            });
    }

    $scope.getTransactions = function getTransactions(merchant) {
        var inputStyle = document.getElementById("searchInput");
        $scope.no_transactions = '';
        $scope.currentMerchant = merchant;
        $scope.transactions = null;
        inputStyle.setAttribute("style", "background: white url(Images/loader.gif) no-repeat scroll 225px 0px;");

        $http({ 
            method: 'GET', 
            url: 'http://localhost/melo.api/transactions?id=' + merchant.Id + '&type=' + merchant.Type + '&rows=' + $scope.rowNumber
            // headers: {
            // 'x-auth-token': sessionStorage.getItem('cko.user').token
            // }
        })
            .then(function successCallback(response) {
                if (response.data != '') {
                    $scope.transactions = response.data;
                    setHealthCheck();
                }
                else {
                    $scope.no_transactions = 'Sorry, no transactions found for ' + $scope.currentMerchant.Name;
                }
                inputStyle.setAttribute("style", "background: white 225px 0px;");
            });
        $scope.search = null;
        $scope.merchants = null;
        $scope.startRefreshTransaction();
    }

    var runningTransaction;
    $scope.startRefreshTransaction = function startRefreshTransaction() {
        if (angular.isDefined(runningTransaction)) $scope.stopRefreshTransaction();
        runningTransaction = $interval(function () {
            $http({ 
                method: 'GET', 
                url: 'http://localhost/melo.api/addTransactions?id=' + $scope.currentMerchant.Id + '&type=' + $scope.currentMerchant.Type + '&chargeId=' + $scope.transactions[0].ChargeId
                // headers: {
                //     'x-auth-token': sessionStorage.getItem('cko.user').token
                // } 
            })
                .then(function successCallback(response) {
                    if (response.data != '') {
                        angular.forEach(response.data, function (value, key) {
                            $scope.transactions.unshift(value);
                        });
                        setHealthCheck();
                    }
                });
        }, 10000);
    };

    $scope.stopRefreshTransaction = function stopRefreshTransaction() {
        if (angular.isDefined(runningTransaction)) {
            $interval.cancel(runningTransaction);
            runningTransaction = undefined;
            $scope.startRefreshTransaction();
        }
    };

    function setHealthCheck(){
        var avgExecTimeCount = [0, 0];
        var capturedCount = 0;
        var authorizedCount = 0;
        var declinedCount = 0;

        angular.forEach($scope.transactions, function(value, key){
            switch(value.Status){
                case 'Declined':
                    declinedCount++;
                    break;
                case 'Authorised':
                    authorizedCount++;
                    break;
                case'Captured':
                    capturedCount++;
                    break;
            }
            avgExecTimeCount[1] += value.GatewayProcessingTime;
            avgExecTimeCount[0]++; 
            console.log(value)
            console.log(avgExecTimeCount[0] + ' : ' + avgExecTimeCount[1] + ' : ' + capturedCount + ' : ' + authorizedCount + ' : ' + declinedCount)
        })

        $scope.avgExecTimeCount = Math.round(avgExecTimeCount[1] / avgExecTimeCount[0]);
        $scope.capturedCount = capturedCount;
        $scope.authorizedCount = authorizedCount;
        $scope.declinedCount = declinedCount;
    };

    $scope.typeEnum = ['Account', 'Business', 'Channel']

    $scope.transactionHeaders = ['Date', 'Charge ID', 'Gateway Response Code', 'Status', 'Is Reattempt', 'Acquirer Response Code', 'Acquirer Response',
'Gateway Processing Time', 'Charge Mode', 'Acquirer Name', 'Customer Email']

});

app.controller('LoginController', function ($scope, $http) {
    $scope.signin = "SIGN IN"

    $scope.login = function login(){
        // $scope.signin = ""
        // var inputStyle = document.getElementById("sign_in_button");
        // inputStyle.setAttribute("style", "background: #33c398 url(Images/Spinner.gif) no-repeat;");
        $scope.loginErrorMessage ="";
        $http({ 
            method: 'POST', 
            url: 'http://localhost:56076/login', 
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded'
            }, 
            data: 'email=' + $scope.username + '&password=' + $scope.password
        })
            .then(function successCallback(response) {
                if (response.data.userId) {
                    sessionStorage.setItem('cko.user', JSON.stringify(response.data));
                    
                    chrome.tabs.getCurrent(function (tab) {
                        chrome.tabs.update(tab.id, {url:chrome.runtime.getURL("main.html")});
                    });
                } else {
                    // inputStyle.setAttribute("style", "background: #33c398;");
                    // $scope.signin = "SIGN IN"
                    $scope.loginErrorMessage = "Invalid user email or password";
                }
            }, function errorCallback(response) {
                // inputStyle.setAttribute("style", "background: #33c398;");
                // $scope.signin = "SIGN IN"
                $scope.loginErrorMessage = "Invalid user email or password";
            });
    }

});