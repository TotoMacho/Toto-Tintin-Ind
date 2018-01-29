document.addEventListener('DOMContentLoaded', function () {
  var text;
  var def1;
  var def2;
  var def3;
  var nbBouton;
  var tabs = [];
  var lines = [];
  var x = 0;
  
  function readTextFile(file)
  {
      var rawFile = new XMLHttpRequest();
      rawFile.open("GET", file, false);
      rawFile.onreadystatechange = function ()
      {
          if(rawFile.readyState === 4)
          {
              if(rawFile.status === 200 || rawFile.status == 0)
              {
                  var allText = rawFile.responseText;
                  text=allText;
                  lines = text.split('\r\n');
                  console.log(lines);
                  for (i=0; i < lines.length; i++){
                        tabs[x] = lines[i].split(';')[0];
                        tabs[x + 1] = lines[i].split(';')[1];
                        x=x+2;
                    } 
                        console.log(tabs);         
                  }      
                  nbBouton = tabs.length;
              }
          }
      
      rawFile.send(null);
  }
  function ajouteBouton(nbBouton){
      var container = document.getElementById("ul1");
      for (i=0; i< nbBouton; i++){
        var btn = document.createElement("BUTTON");        // Create a <button> element
        var t = document.createTextNode(tabs[i]);       // Create a text node
        btn.appendChild(t);                                // Append the text to <button>
        btn.id = tabs[i];
        container.appendChild(btn);
        $element = document.getElementById(tabs[i]);
        document.getElementById(tabs[i]).setAttribute("data-scroll-speed", "9")
        $element.classList.add("box");
        i++;
      }     
  }

  function changeText(){
    var str = this.id;
    for(i=0; i < nbBouton; i++){
        if(str === tabs[i]){
            document.getElementById("text").innerHTML=tabs[i+1];
        }
    }
    
    
  }
readTextFile("file:///C:/CCTL/Melo/test.txt");

ajouteBouton(nbBouton);

var buttons = document.getElementsByTagName("button");

for (x=0;x < buttons.length;x++){
    document.querySelector("#"+buttons[x].id).addEventListener('click', changeText);
}

disp=document.getElementById("login");
function myFunction(){
if(disp.style.display == "none"){
    disp.style.display="";
    var bodyStyle = document.getElementById("content").style;
    //bodyStyle.transform = "none";
    window.parent.postMessage({message: 'show'}, '*');
  
}else{
    disp.style.display="none";
    var bodyStyle = document.getElementById("content").style;
    var cssTransform = 'transform' in bodyStyle ? 'transform' : 'webkitTransform';
    //bodyStyle[cssTransform] = 'translateY(' + 40 + 'px)';
    
    window.parent.postMessage({message: 'hide'}, '*');
}
}

document.getElementById("btn").addEventListener('click', myFunction);
});