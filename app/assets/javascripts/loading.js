$(document).ready(function(){
  console.log("WORKING???");
  var loadingDiv = document.querySelector('.loading');
  if (loadingDiv){
    setTimeout(function(){
      loadingDiv.style.display = "none";
    }, 4000);
  }
});
