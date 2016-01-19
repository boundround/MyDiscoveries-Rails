(function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable time_event track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.union people.track_charge people.clear_charges people.delete_user".split(" ");
for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?MIXPANEL_CUSTOM_LIB_URL:"file:"===e.location.protocol&&"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f)}})(document,window.mixpanel||[]);
mixpanel.init("de052d33122e3f958caca2e9c4eef0bb");


// setup profile
$(document).ready(function(){
	identity = $("body").data('mixpanel-identity');
	if (identity)
	{
		id = identity.split('-').pop();
		mixpanel.identify(id);

		//track signed in user
		if ($('.recently_signed_in').length)
		{
			mixpanel.people.set({'$last_login': new Date()});
			mixpanel.track('Signed In', {'date': new Date()});
			$('.recently_signed_in').remove();
		}

		//track visited page

		mixpanel.track('Visit Page', {'title': $('title').text()});

		// track signed out user
		$(document).on('click', 'a.sign-out', function(e){
			mixpanel.track('Signed Out', {'date': new Date()});
		});

		// track video click
		$(document).on('click', '.bg-play',function(e){
			mixpanel.track("Play Video")
		});

		// track photo click

		// track story click

		//track review

		//track search result click

		$(document).on('mousedown', '.hit-result', function(e){
			if (e.which == 1 || e.which == 2)
			{
				mixpanel.track('Hit Result', {"title" : $(this).find('.hit-name').text()})
			}
		});

	}
})