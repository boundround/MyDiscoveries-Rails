$(document).ready(function(){
  //FUNCTION TO GET QUERY PARAMETERS FROM URL
  var QueryString = function () {
    // This function is anonymous, is executed immediately and
    // the return value is assigned to QueryString!
    var query_string = {};
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i=0;i<vars.length;i++) {
      var pair = vars[i].split("=");
          // If first entry with this name
      if (typeof query_string[pair[0]] === "undefined") {
        query_string[pair[0]] = decodeURIComponent(pair[1]);
          // If second entry with this name
      } else if (typeof query_string[pair[0]] === "string") {
        var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
        query_string[pair[0]] = arr;
          // If third or later entry with this name
      } else {
        query_string[pair[0]].push(decodeURIComponent(pair[1]));
      }
    }
      return query_string;
  }();

  var dualListBox = function(selector, ids, selectBox){
    dt_controller = $('#similar-places-js').data("controllers")

    if (selector.length > 0) {
      if (ids.length > 0){
        for(var i = 0; i < ids.length; i++){
          if (ids[i] !== "nil"){
            if (dt_controller == 'attractions') {
              $(selectBox).append("<option value='" + ids[i]['attraction_id'] +
                              "' name=" + ids[i]['attraction_name'] +
                              "' >" + ids[i]['attraction_name'] + "</option>");
            } else if (dt_controller == 'regions') {
              $(selectBox).append("<option value='" + ids[i]['region_id'] +
                              "' name=" + ids[i]['region_name'] +
                              "' >" + ids[i]['region_name'] + "</option>");
            } else {
              $(selectBox).append("<option value='" + ids[i]['place_id'] +
                              "' name=" + ids[i]['place_name'] +
                              "' >" + ids[i]['place_name'] + "</option>");
            }
          }
        }
      }
    }
  }


  if (QueryString.video){
    var video = $('#' + QueryString.video)[0];
    if (video){
      data_src = $(video).data("video-url");
      $("#video-modal iframe").prop("src", data_src);
      $("#video-modal").modal("show");
    }
  }

  if (QueryString.modal === 'true'){
    $('#one-minute-modal').modal('show');
  }

  dualListBox($('#dual-list-box-Places'), $('#similar-places-js').data("similar"), $("[name*='places_post[place_ids][]']"));
  dualListBox($('#dual-list-box-stories-places'), $('#similar-places-js').data("similar"), $("[name*='places_story[place_ids][]']"));
  dualListBox($('#dual-list-box-stories-attractions'), $('#similar-places-js').data("similar"), $("[name*='attractions_story[attraction_ids][]']"));
  dualListBox($('#dual-list-box-stories-regions'), $('#similar-places-js').data("similar"), $("[name*='regions_story[region_ids][]']"));


  if($("#dual-list-box-stories-countries").length > 0){
    var availableCountries = $('#dual-list-box-stories-countries');
    var similar_ids = $('#similar-countries-js').data("similar");
    var selectBox = $("[name*='countries_story[country_ids][]']");
    if(similar_ids.length > 0){
      for (var i = 0; i < similar_ids.length; i++){
        //availableCountries.find($("[name*='" + similar_ids[i]['country_name'] + "'")).remove();
        if (similar_ids[i] !== "nil"){
          $(selectBox).append("<option value='" + similar_ids[i]['country_id'] +
                              "' name=" + similar_ids[i]['country_name'] +
                              "' >" + similar_ids[i]['country_name'] + "</option>")
        }
      }
    }
  }

  if($("#dual-list-box-Countries").length > 0){
    var availableCountries = $('#dual-list-box-Countries');
    var similar_ids = $('#similar-countries-js').data("similar");
    var selectBox = $("[name*='countries_post[country_ids][]']");
    if(similar_ids.length > 0){
      for (var i = 0; i < similar_ids.length; i++){
        //availableCountries.find($("[name*='" + similar_ids[i]['country_name'] + "'")).remove();
        if (similar_ids[i] !== "nil"){
          $(selectBox).append("<option value='" + similar_ids[i]['country_id'] +
                              "' name=" + similar_ids[i]['country_name'] +
                              "' >" + similar_ids[i]['country_name'] + "</option>")
        }
      }
    }
  }

  if ($("#dual-list-box-Destinations").length > 0){
    console.log("Similar Places");
    var availableDestinations = $('#dual-list-box-Destinations');
      var similar_ids = $('#similar-places-js').data("similar");
      var selectBox = $("[name*='similar_place[similar_place_ids][]']");
      if(similar_ids.length > 0){
        for (var i = 0; i < similar_ids.length; i++){
          //availableDestinations.find($("[name*='" + similar_ids[i]['place_name'] + "'")).remove();
          if (similar_ids[i] !== "nil"){
            $(selectBox).append("<option value='" + similar_ids[i]['place_id'] +
                                "' name=" + similar_ids[i]['place_name'] +
                                "' >" + similar_ids[i]['place_name'] + "</option>")
          }
        }
      }
    }

    if($("#place_is_area").length > 0){

    if ($('#place_is_area').is(":checked")){
      $('.js-primary-category').hide();
      $('.js-special-requirements').hide();
    }

    if($('#place_special_requirements').val().length > 0){
      $('#special-requirements-box').prop('checked', true);
      $('.js-special-requirements').show();
    } else {
      $('.js-special-requirements').hide();
    }

    $('#place_is_area').change(function(){
      if ($('#place_is_area').is(":checked")){
        $('.js-primary-category').hide();
      } else {
        $('.js-primary-category').show();
      }
    });

    $('#special-requirements-box').change(function(){
      if ($('#special-requirements-box').is(":checked")){
        $('.js-special-requirements').show();
      } else {
        $('.js-special-requirements').hide();
        $('#place_special_requirements').val("");
      }
    });
  }

  var controller = $("[data-action='onload']").data('controller');
  $(function(){
    $("input[type=radio][name=parentable_chose]").change(function(){
      id_chosen = $(this).attr('id')
      
      if (id_chosen == 'parentable_chose_country'){
        if (controller == 'regions'){
          document.getElementById('chosen_country').style.display = "";
        } else {
          document.getElementById('chosen_country').style.display = "";
          document.getElementById('chosen_region').style.display = "none";
          document.getElementById('chosen_place').style.display = "none";
          if (controller == 'attractions'){
            document.getElementById('chosen_attraction').style.display = "none";
          }
        }

        if ($(this).val() == 'country'){
          if (controller == 'regions'){
            $('.place_parent_attributes_parentable_type_country').val('Country')
          } else {
            $('#chosen_place').find('select').val('')
            $('#chosen_region').find('select').val('')
            $('#chosen_attraction').find('select').val('')
            $('.place_parent_attributes_parentable_type_place').val('Country')
            $('.place_parent_attributes_parentable_type_country').val('Country')
            $('.place_parent_attributes_parentable_type_region').val('Country')
            if (controller == 'attractions'){
              $('.place_parent_attributes_parentable_type_attraction').val('Country')
            }
          }
        }
      }

      else if (id_chosen == 'parentable_chose_region') {
        document.getElementById('chosen_region').style.display = "";
        document.getElementById('chosen_place').style.display = "none";
        document.getElementById('chosen_country').style.display = "none";
        if (controller == 'attractions'){
          document.getElementById('chosen_attraction').style.display = "none";
        }

        if ($(this).val() == 'region'){
          $('#chosen_place').find('select').val('')
          $('#chosen_country').find('select').val('')
          $('#chosen_attraction').find('select').val('')
          $('.place_parent_attributes_parentable_type_place').val('Region')
          $('.place_parent_attributes_parentable_type_region').val('Region')
          $('.place_parent_attributes_parentable_type_country').val('Region')
          if (controller == 'attractions'){
            $('.place_parent_attributes_parentable_type_attraction').val('Region')
          }
        }
      }

      else if (id_chosen == 'parentable_chose_place') {
        document.getElementById('chosen_place').style.display = "";
        document.getElementById('chosen_region').style.display = "none";
        document.getElementById('chosen_country').style.display = "none";
        if (controller == 'attractions'){
          document.getElementById('chosen_attraction').style.display = "none";
        }

        if ($(this).val() == 'place'){
          $('#chosen_country').find('select').val('')
          $('#chosen_region').find('select').val('')
          $('#chosen_attraction').find('select').val('')
          $('.place_parent_attributes_parentable_type_place').val('Place')
          $('.place_parent_attributes_parentable_type_region').val('Place')
          $('.place_parent_attributes_parentable_type_country').val('Place')
          if (controller == 'attractions'){
            $('.place_parent_attributes_parentable_type_attraction').val('Place')
          }
        }
      }

      else if (id_chosen == 'parentable_chose_attraction') {
        document.getElementById('chosen_attraction').style.display = "";
        document.getElementById('chosen_place').style.display = "none";
        document.getElementById('chosen_region').style.display = "none";
        document.getElementById('chosen_country').style.display = "none";

        if ($(this).val() == 'attraction'){
          $('#chosen_country').find('select').val('')
          $('#chosen_region').find('select').val('')
          $('#chosen_place').find('select').val('')
          $('.place_parent_attributes_parentable_type_place').val('Attraction')
          $('.place_parent_attributes_parentable_type_country').val('Attraction')
          $('.place_parent_attributes_parentable_type_region').val('Attraction')
          $('.place_parent_attributes_parentable_type_attraction').val('Attraction')
        }
      }

    });
  });

  if ($('#parentable_chose_country').is(':checked') == true) {
    document.getElementById('chosen_country').style.display = "";
    
    if (controller == 'regions'){
      $('.place_parent_attributes_parentable_type_country').val('Country')
    } else {
      $('#chosen_place').find('select').val('')
      $('#chosen_region').find('select').val('')
      if (controller == 'attractions'){
        $('#chosen_attraction').find('select').val('')
      }
      $('.place_parent_attributes_parentable_type_place').val('Country')
      $('.place_parent_attributes_parentable_type_country').val('Country')
      $('.place_parent_attributes_parentable_type_attraction').val('Country')
      $('.place_parent_attributes_parentable_type_region').val('Country')
    }
  }

  if ($('#parentable_chose_region').is(':checked') == true) {
    document.getElementById('chosen_region').style.display = "";
    
    $('#chosen_country').find('select').val('')
    $('#chosen_place').find('select').val('')
    if (controller == 'attractions'){
      $('#chosen_attraction').find('select').val('')
    }
    $('.place_parent_attributes_parentable_type_place').val('Region')
    $('.place_parent_attributes_parentable_type_country').val('Region')
    $('.place_parent_attributes_parentable_type_attraction').val('Region')
    $('.place_parent_attributes_parentable_type_region').val('Region')
  }

  if ($('#parentable_chose_place').is(':checked') == true) {
    document.getElementById('chosen_place').style.display = "";
    
    $('#chosen_country').find('select').val('')
    $('#chosen_region').find('select').val('')
    if (controller == 'attractions'){
      $('#chosen_attraction').find('select').val('')
    }
    $('.place_parent_attributes_parentable_type_place').val('Place')
    $('.place_parent_attributes_parentable_type_country').val('Place')
    $('.place_parent_attributes_parentable_type_attraction').val('Place')
    $('.place_parent_attributes_parentable_type_region').val('Place')
  }

  if ($('#parentable_chose_attraction').is(':checked') == true) {
    document.getElementById('chosen_attraction').style.display = "";
    
    $('#chosen_country').find('select').val('')
    $('#chosen_place').find('select').val('')
    $('#chosen_region').find('select').val('')
    $('.place_parent_attributes_parentable_type_place').val('Attraction')
    $('.place_parent_attributes_parentable_type_country').val('Attraction')
    $('.place_parent_attributes_parentable_type_attraction').val('Attraction')
    $('.place_parent_attributes_parentable_type_region').val('Attraction')
  }

});

function countChars(countfrom,displayto) {
  var len = document.querySelector(countfrom).value.length;
  document.querySelector(displayto).innerHTML = len;
}