(function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable time_event track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.union people.track_charge people.clear_charges people.delete_user".split(" ");
for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?MIXPANEL_CUSTOM_LIB_URL:"file:"===e.location.protocol&&"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f)}})(document,window.mixpanel||[]);
mixpanel.init("29fd59c6aae9e194b4072c3e0e5e2b1b");


function mouse_click_on_middle_or_left(e)
{
	if (e.which == 1 || e.which == 2) {return true}
	return false
}

function toTitleCase(str)
{
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

// setup profile
$(document).ready(function(){
	identity = $("body").data('mixpanel-identity');
	if (identity)
	{
		id = identity.split('-').pop();
		mixpanel.identify(id);
		if ($('body').hasClass('signed-in'))
		{
			options = {}
		}else{
			options = {"ip": id}
		}

		//track sign up
		//user view sign up page
		$(document).on('mousedown', 'a[href="/users/sign_up"]', function(e){
			mouse_click_on_middle_or_left(e) ? mixpanel.track("View sign up page") : null;
		});
		// user submit sign up form
		$(document).on('submit', 'form[action="/users"][method="post"]', function(e){
			mixpanel.track("Submits sign up form");
		});
		//user close signup form
		$(document).on('click', 'a.close-signup', function(){
			mixpanel.track("Closes sign up form");
		});

		//track user sign in
		//user open login modal
		$("div#signInModal").on("show.bs.modal", function(e){
			mixpanel.track("Open sign in modal form");
		});
		$("div#signInModal").on("hide.bs.modal", function(e){
			mixpanel.track("Closes sign in modal form");
		});
		// user use instagram to login
		$(document).on("mousedown", 'a[href="/users/auth/instagram"]', function(e){
			mouse_click_on_middle_or_left(e) ? mixpanel.track("Open Sign in with instagram") : null ;
		});
		//user signed in with instagram
		if ($('.recently_signed_in_with_instagram').length)
		{
			mixpanel.people.set({'$last_login' : new Date()});
			opts = $.extend(options, {'date': new Date()})
			mixpanel.track('Signed in with instagram', opts);
			$('.recently_signed_in_with_instagram').remove();
		}
		//user failed sign in with instagram
		if ($('.recently_failed_signed_in_with_instagram').length)
		{
			opts = $.extend(options, {'date': new Date()})
			mixpanel.track('Failed sign in with instagram', opts);
		}
		//user open forgot password
		$(document).on("mousedown", 'a[href="/users/password/new"]', function(e){
			mouse_click_on_middle_or_left(e) ? mixpanel.track("Open forgot password form") : null ;
		});
		// user submit sign in form
		$(document).on("submit", 'form[action="/users/sign_in"][method="post"]', function(e){
			mixpanel.track("Submit sign in form");
		});
		//user signed in
		if ($('.recently_signed_in').length)
		{
			mixpanel.people.set({'$last_login': new Date()});
			opts = $.extend(options, {'date': new Date()})
			mixpanel.track('Signed In', opts);
			$('.recently_signed_in').remove();
		}

		// if alert present then assume user failed to sign in before
		if ($('div.alert-warning').length && $('form[action="/users/sign_in"][method="post"]').length)
		{
			mixpanel.track("Failed to sign in");
		}

		//track visited page
		opts = $.extend(options, {'title': $('title').text()});
		mixpanel.track('Visits page '+$('title').text(), opts);

		// track signed out user
		$(document).on('click', 'a.sign-out', function(e){
			opts = $.extend(options, {'date': new Date()})
			mixpanel.track('Signed Out', opts);
		});

		// track video click
		$(document).on('click', '.bg-play',function(e){
			mixpanel.track("Click video")
		});

		// track photos click
		// track when user click his photos index
		$(document).on("mousedown", 'a[href="/users/phosts"]', function(e){
			mixpanel.track("Click user's photos");
		});
		//track user when click new photo modal
		new_user_photo_form = $('form[action="/user_photos/profile_create"][method="post"]');
		if (new_user_photo_form.length)
		{
			modal = new_user_photo_form.parents("div.modal");
			if (modal.length)
			{
				modal.on("show.bs.modal", function(e){
					mixpanel.track("Opens new photo modal form");
				});
				modal.on("hide.bs.modal", function(e){
					mixpanel.track("Close new photo modal form");
				});
			}
		}

		new_place_photo_form = $('form[action^="/places/"][action$="/user_photos"]');
		if (new_place_photo_form.length)
		{
			action_arr = new_place_photo_form.attr('action').split("/");
			place_name = action_arr.pop();
			place_name = action_arr.pop();
			place_name = toTitleCase(place_name.split('-').join(' '))
			opts = opts = $.extend(options, {"place": place_name});

			modal = new_place_photo_form.parents('div.modal');
			if (modal.length)
			{
				modal.on("show.bs.modal", function(e){
					mixpanel.track("Opens create photo form on place "+place_name);
				});
				modal.on("hide.bs.modal", function(e){
					mixpanel.track("Close create photo form on place "+place_name);
				});
			}
			new_place_photo_form.on("submit", function(e){
				mixpanel.track("Submit photo on "+place_name, opts);
			});

			$("div#user-photo-upload-button .btn").on("click", function(e){
				mixpanel.track("Submit photo on "+place_name, opts);
			});		 
		}

		// track places click
		// track user when click place links
		$(document).on("click", 'a[href^="/places/"]', function(e){
			place_name = $(this).attr("href").split("/").pop();
			place_name = place_name.split("#").shift();
			place_name = toTitleCase(place_name.split("-").join(' '))
			opts = $.extend(options, {"place": place_name});
			mixpanel.track("Clicks link to place "+place_name, opts)
			//mouse_click_on_middle_or_left(e) ? mixpanel.track("Clicks link to place "+place_name, opts) : null;
		});

		// track stories click
		// track display user story index
		$(document).on("mousedown", 'a[href="/users/stories"]', function(e){
			mouse_click_on_middle_or_left(e) ? mixpanel.track("Click user's stories") : null;
		});
		// track when user create story
		if ($('form[action="/stories/profile_create"][method="post"]').length)
		{
			user_story_form = $('form[action="/stories/profile_create"][method="post"]');
			modal = user_story_form.parents('div.modal');
			if (modal.length)
			{
				// track user when click new story modal
				modal.on("show.bs.modal", function(e){
					mixpanel.track("Open new story modal form");
				});
				// track user when close new story modal
				modal.on("hide.bs.modal", function(e){
					mixpanel.track("Closes new story modal form");
				});	
			}
			$(document).on("submit", 'form[action="/stories/profile_create"][method="post"]', function(e){
				mixpanel.track("Submit new user story");
			});
		}
		//track user when click read story
		$(document).on("click", 'a#userStory', function(e){
			opts = $.extend(options, {"title": $(this).data("title")});
			mixpanel.track("View story on his story index", opts);
		});
		//track user when create story for some places
		if ($('form[action^="/places/"][action$="/stories"]').length)
		{
			leave_story_form = $('form[action^="/places/"][action$="/stories"]');
			action_arr = leave_story_form.attr('action').split("/");
			place_name = action_arr.pop();
			place_name = action_arr.pop();
			place_name = toTitleCase(place_name.split('-').join(' '))
			opts = opts = $.extend(options, {"place": place_name});
			
			modal = leave_story_form.parents('div.modal');
			if (modal.length)
			{
				modal.on("show.bs.modal", function(e){
					mixpanel.track("Opens create story form on place "+place_name);
				});
				modal.on("hide.bs.modal", function(e){
					mixpanel.track("Close create story form on place "+place_name);
				});
			}
			leave_story_form.on("submit", function(e){
				mixpanel.track("Submit story on "+place_name, opts);
			});		
		}

		//track review
		//track user when click user review index
		$(document).on("mousedown", 'a[href="users/reviews"]', function(e){
			mouse_click_on_middle_or_left(e) ? mixpanel.track("Display his reviews") : null;
		});
		// track user when open leave review form
		if ($('form[action^="/places/"][action$="/reviews"]').length)
		{
			console.log('asup');
			leave_review_form = $('form[action^="/places/"][action$="/reviews"]');
			action_arr = leave_review_form.attr('action').split("/");
			place_name = action_arr.pop();
			place_name = action_arr.pop();
			place_name = toTitleCase(place_name.split('-').join(' '))
			opts = $.extend(options, {"place": place_name});
			
			modal = leave_review_form.parents('div.modal');
			if (modal.length)
			{
				modal.on("show.bs.modal", function(e){
					mixpanel.track("Opens review form on place "+place_name);
				});
				modal.on("hide.bs.modal", function(e){
					mixpanel.track("Close review form on place"+place_name);
				});
			}
			leave_review_form.on("submit", function(e){
				mixpanel.track("Submit review on "+place_name, opts);
			});
		}
		//track search result click

		$(document).on('mousedown', '.hit-result', function(e){
			if (mouse_click_on_middle_or_left(e))
			{
				opts = $.extend(options, {"title" : $(this).find('.hit-name').text(), "query": $('input#search-box').val()});
				mixpanel.track('Hit Result', opts);
			}
		});

		// track user when edit his profile
		user_profile_form = $('form.edit_user');
		if (user_profile_form.length)
		{
			if (user_profile_form.find('input[name="_method"]').val() == 'patch')
			{
				modal = user_profile_form.parents('div.modal');
				if (modal.length)
				{
					modal.on("show.bs.modal", function(e){
						mixpanel.track("Opens edit profile form");
					});
					modal.on("hide.bs.modal", function(e){
						mixpanel.track("Close edit profile form");
					});
				}
				user_profile_form.on("submit", function(){
					mixpanel.track("Submit edit profile form");
				});
			}
		}

	}
})
