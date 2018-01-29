
chrome.browserAction.onClicked.addListener(function (tab) {
  chrome.windows.create({
    url: chrome.runtime.getURL("login.html"),
    type: "popup",
    height: 500,
    width: 1100
  });
});

