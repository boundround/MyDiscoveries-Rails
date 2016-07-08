(function(){
  console.log("TA");
  var TRIP_ADVISOR_KEY = "6cd1112100c1424a9368e441f50cb642";
  $.ajax({
    url: "//api.tripadvisor.com/api/partner/2.0/location/256522?key=" + TRIP_ADVISOR_KEY,
    type: "GET",
    success: function(data){
      console.log(data);
    }
  });
})();
