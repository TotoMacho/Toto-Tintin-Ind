
var height = '60px';
var iframe = document.createElement('iframe');
iframe.id = "myframe";
iframe.name = "myframe";
iframe.src = chrome.extension.getURL('toolbar.html');
iframe.style.height = height;
iframe.style.width = '100%';
iframe.style.position = 'bottom';
iframe.style.top = '0px';
iframe.style.left = '0px';
iframe.style.zIndex = '938089'; // Some high value
iframe.style.backgroundColor = 'white'
iframe.scrolling = 'no'
iframe.frameBorder = '0'
// Etc. Add your own styles if you want to
document.body.appendChild(iframe);


var bodyStyle = document.body.style;
var cssTransform = 'transform' in bodyStyle ? 'transform' : 'webkitTransform';


document.addEventListener("touchstart", function(){}, true)
frame = document.getElementById('myframe');

window.addEventListener('message', function(event) {
    disp=document.getElementById("login");
    if(event.data.message === "hide")
    {
        frame.style.height = "20px";
        
      
    }else if(event.data.message === "show")
    {
        frame.style.height = height;
        
    }

  }, false);
