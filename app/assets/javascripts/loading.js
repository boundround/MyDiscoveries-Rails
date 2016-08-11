$(document).ready(function(){
  var loadingDiv = document.querySelector('.loading');
  if (loadingDiv){
    setTimeout(function(){
      loadingDiv.style.display = "none";
    }, 4000);
  }
});
