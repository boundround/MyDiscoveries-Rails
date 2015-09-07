// Search Box

// Save User Location

/*global google*/
/*global br_map*/

window.onload = function() {

	var br_search_button_class = '.search-button'; //".search-button" when integrated
	var br_search_class = '.search-box'; //".search-box" when integrated
	var br_url_prefix = '';//'https://app.boundround.com'; //Blank when integrated

	var iOS = (navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false);

	//	var userIP = $('#user-ip').data('ip');
	var userIP = '';
	var userCity = '';
	var userCountry = '';

	/*
		function myIP() {
		    if (window.XMLHttpRequest) xmlhttp = new XMLHttpRequest();
		    else xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		
		    xmlhttp.open("GET","http://api.hostip.info/get_html.php",false);
		    xmlhttp.send();
		
		    hostipInfo = xmlhttp.responseText.split("\n");
		
		    for (i=0; hostipInfo.length >= i; i++) {
		        ipAddress = hostipInfo[i].split(":");
		        if ( ipAddress[0] == "IP" ) return ipAddress[1];
		    }
		
		    return false;
		}
	*/

	$.ajax('https://freegeoip.net/json/')
		.done(function(data) {
			userIP = data.ip;
			userCity = data.city;
			userCountry = data.country_name;
		})
		.fail(function() {
			$.ajax('http://ipinfo.io/json/')
				.done(function(data) {
					userIP = data.ip;
					userCity = data.city;
					userCountry = data.country;
				})
		});


	var googlePlaceSearch = function(request, response) {
		function initialize() {
			var service = new google.maps.places.AutocompleteService();
			service.getPlacePredictions({
				input: request.term
			}, callback);
		}

		function callback(predictions, status) {
			if (status != google.maps.places.PlacesServiceStatus.OK) {
				alert(status);
				return;
			}
			response($.map(predictions, function(item) {
				return {
					label: item.description,
					value: item.description,
					lat: -33.865143,
					lng: 151.2099,
					resultType: 'Google',
					placeId: item.place_id
				}
			}));
		}
		initialize();
	}


	var createNewPlaceFromGooglePlaces = function(place_id, city, country, userIP) {
		var service = new google.maps.places.PlacesService(br_map);
		var placeDetails;
		var request = {
			placeId: place_id
		};
		service.getDetails(request, function(place, status) {
			if (status == google.maps.places.PlacesServiceStatus.OK) {
				$.ajax({
					url: br_url_prefix + "/places/user_create.js",
					type: "POST",
					data: {
						place: {
							display_name: place.name,
							display_address: place.formatted_address,
							latitude: place.geometry.location.lat(),
							longitude: place.geometry.location.lng(),
							phone_number: place.formatted_phone_number,
							website: place.website,
							status: "live",
							place_id: place_id,
							user_created: true,
							subscription_level: "basic"
						}
					},
					success: function(data) {
						if (data.place_id !== "error") {
							window.location.href = br_url_prefix + "/places/" + data.place_id;
						}
						else {
							setViewForGooglePlace(place_id, city, country, userIP);
						}
					}
				});
			}
		});
	}

	var googlePlaceSearch = function(request, response) {
		function initialize() {
			var service = new google.maps.places.AutocompleteService();
			service.getPlacePredictions({
				input: request.term
			}, callback);
		}

		function callback(predictions, status) {
			if (status != google.maps.places.PlacesServiceStatus.OK) {
				alert(status);
				return;
			}
			response($.map(predictions, function(item) {
				return {
					label: item.description,
					value: item.description,
					lat: -33.865143,
					lng: 151.2099,
					resultType: 'Google',
					placeId: item.place_id
				}
			}));
		}
		initialize();
	}

	var createNewPlaceFromGooglePlaces = function(place_id, city, country, userIP) {
		var service = new google.maps.places.PlacesService(br_map);
		var placeDetails;
		var request = {
			placeId: place_id
		};
		service.getDetails(request, function(place, status) {
			if (status == google.maps.places.PlacesServiceStatus.OK) {
				console.log(place);
				$.ajax({
					url: br_url_prefix + "/places/user_create.js",
					type: "POST",
					data: {
						place: {
							display_name: place.name,
							display_address: place.formatted_address,
							latitude: place.geometry.location.lat(),
							longitude: place.geometry.location.lng(),
							phone_number: place.formatted_phone_number,
							website: place.website,
							status: "live",
							place_id: place_id,
							user_created: true,
							subscription_level: "basic"
						}
					},
					success: function(data) {
						if (data.place_id !== "error") {
							window.location.href = br_url_prefix + "/places/" + data.place_id;
						}
						else {
							setViewForGooglePlace(place_id, city, country, userIP);
						}
					}
				});
			}
		});
	}
	var setViewForGooglePlace = function(place, city, country, userIP) {
		geocoder = new google.maps.Geocoder();
		geocoder.geocode({
			address: place
		}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				// new API results for Google Places
				console.log("RESULTS: " + results[0].geometry.location.lat());
				var location = [results[0].geometry.location.lat(), results[0].geometry.location.lng()];
				// $('#svgdiv').fadeOut("fast");
				//   map.setView( location, 9 );

				// var popup = L.popup()
				//   .setLatLng(location)
				//   .setContent('<h3>' + place + '</h3><br><button type="button" class="want-button" class="btn btn-default btn-md"><span class="glyphicon glyphicon-thumbs-up"></span> I Want This in Bound Round</button>')
				//   .openOn(map);
				var placeCard = place + '-card';
				var areas = $('#areas');
				var content = '<div class="want-card"><div class="area-title">' + place + '<br><button type="button" class="want-button" class="btn btn-default btn-md"><span class="glyphicon glyphicon-thumbs-up"></span> I Want This in Bound Round</button></div></div>';
				areas.append(content);
				$('#places').empty();

				$('.want-button').on('click', function(e) {
					$('.want-button').hide();
					$('.leaflet-popup-content').append("Thanks we're on it!");
					areas.find('.area-card').html("<br><h3 style='text-align:center'>Thanks, we're on it!</h3>");

					$.ajax({
						type: "POST",
						url: br_url_prefix + '/notification',
						data: {
							place: place,
							city: city,
							country: country,
							userIP: userIP
						},
						success: console.log('sent: ' + place),
					});
				});
			}
			else {
				console.log(status);
			}
		});
	};




	$(br_search_class).autocomplete({
		autoFocus: true,
		//source: "/search_suggestions.json?term=" + request.term
		source: function(request, response) {
			var combinedData = {};
			var localComplete = false;
			var factualComplete = false;

			// ajax call to local database (soulmate server) for bound round places
			$.ajax({
				beforeSend: function() {
					$('.search-spinner').css('visibility', 'visible');
				},
				url: br_url_prefix + '/sm/search?types[]=place&types[]=area&types[]=country&limit=100&term=' + request.term,
				success: function(data) {
					combinedData = $.map(data.results.place.concat(data.results.area).concat(data.results.country), function(item) {
						var areaDisplay = null;
						if (item.hasOwnProperty('area')) {
							if (item.area.display_name == item.area.country) {
								areaDisplay = item.area.display_name;
							}
							else {
								areaDisplay = item.area.display_name + ", " + item.area.country;
							};
						};

						if (item.hasOwnProperty('country')) {
							areaDisplay = item.country ? item.country : "";
						}

						return {
							label: item.display_name + (areaDisplay ? ", " + areaDisplay : ""),
							value: item.display_name,
							lat: item.latitude,
							lng: item.longitude,
							resultType: item.placeType,
							place_id: item.slug
						}
					});

					$('.search-button').on('click', function() {
						var e = $.Event('keypress');
						e.which = 13; // Character 'A'
						$(this).trigger(e);
						// $('#search-box').data('ui-autocomplete')._trigger('select', 'autocompleteselect', {item: data[0]});
					});
				},
				complete: function() {
					combineResults(request.term);
				}
			});

			// ajax call to Factual API for more places
			// $.ajax({
			//   url: '/factual_places/search.json?term=' + request.term,
			//   success: function(data){
			//     var factualData = $.map(data, function(item){
			//       return {
			//         label: item.name,
			//         value: item.name,
			//         lat: item.latitude,
			//         lng: item.longitude,
			//         resultType: "factual",
			//         place_id: "#"
			//       }
			//     });
			//     console.log(data);
			//     console.log(combinedData);
			//     combinedData = combinedData.concat(factualData)

			//   },

			//   complete: function(){
			//     factualComplete = true;
			//     factualComplete && localComplete && combineResults();
			//   }
			// });

			function combineResults(searchTerm) {
				var lastIndex = 0;
				$('.search-spinner').css('visibility', 'hidden');
				if (combinedData.length >= 1) {
					// Sort places that start with search term first
					for (var i = 0; i < combinedData.length; i++) {
						var term = request.term.toLowerCase();
						if (combinedData[i]["label"].toLowerCase().match("^" + term)) {
							var temp = combinedData.splice(i, 1);
							combinedData = temp.concat(combinedData);
							lastIndex = i;
						}
					}
					// Sort places with search term in name somewhere next
					for (lastIndex; combinedData.length < lastIndex; lastIndex++) {
						var term = request.term.toLowerCase();
						if (combinedData[lastIndex]["label"].toLowerCase().match(term)) {
							var temp = combinedData.splice(lastIndex, 1);
							combinedData = temp.concat(combinedData);
						}
					}
					combinedData = combinedData.slice(0, 6);
					response(combinedData);
				}
				else {
					googlePlaceSearch(request, response);
				}
			}
		},
		minLength: 2,
		select: function(event, ui) {
			$.ajax({
				type: "POST",
				url: br_url_prefix + '/searchqueries/create',
				data: {
					search_query: {
						term: this.value,
						source: ui.item.resultType,
						city: userCity,
						country: userCountry
					}
				},
				success: console.log('saved: ' + ui.item.label)
			});

			var newZoom = 9;
			if (ui.item.resultType === 'place') {
				// newZoom = 13;
				// $('#svgdiv').fadeOut("fast");
				// console.log(ui.item.lat + ', ' + ui.item.lng + ' ' + ui.item.resultType);
				// map.setView( [ui.item.lat, ui.item.lng], newZoom );
				// window.resultCard = $('#' + ui.item.place_id);
				// console.log("saving result card");
				// showAreaCards();
				// showPlaceCards();
				window.location.href = br_url_prefix + "/places/" + ui.item.place_id;
			}
			else if (ui.item.resultType === 'area') {
				window.location.href = br_url_prefix + "/areas/" + ui.item.place_id;
			}
			else if (ui.item.resultType === 'country') {
				window.location.href = br_url_prefix + "/countries/" + ui.item.place_id;
			}

			if (ui.item.resultType === 'Google') {
				var newLat, newLng;
				geocoder = new google.maps.Geocoder();
				geocoder.geocode({
					address: ui.item.label
				}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						// new API results for Google Places
						newLat = results[0].geometry.location.lat();
						newLng = results[0].geometry.location.lng();
					}
					$.ajax({
						beforeSend: function() {
							$('.new-page-spinner').css('visibility', 'visible');
						},
						url: br_url_prefix + '/factual_places/search.json?term=' + ui.item.label + '&lat=' + newLat + '&lng=' + newLng,
						success: function(data) {
							$('.new-page-spinner').css('visibility', 'hidden');
							if (data.length > 0) {
								createNewPlaceFromGooglePlaces(ui.item.placeId, userCity, userCountry, userIP /*$('#user-ip').data("ip")*/ );
							}
							else {
								setViewForGooglePlace(ui.item.label, userCity, userCountry, userIP /* $('#user-ip').data("ip")*/ );
							}
						}
					});
				});
			}

			if (typeof brglobe != 'undefined') {
				brglobe.setLocation(ui.item.lat, ui.item.lng);
			}

			document.activeElement.blur();

		},
		open: function() {
			$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
		},
		close: function() {
			$(this).removeClass("ui-corner-top").addClass("ui-corner-all");
		}
	});

	//	cardHover();
}
