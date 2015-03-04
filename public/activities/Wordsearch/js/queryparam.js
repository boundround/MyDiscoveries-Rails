//Modify an object containing properties assigned from the url query parameters
function adjustFromQueryParams(settings)
{
  var parameters = location.search.substring(1).split("&");

	if(parameters.length > 0 && parameters[0] !== "")
	{
		for(i = 0; i < parameters.length; i++)
		{
			var keyval = parameters[i].split("=");

			var key = decodeURIComponent(keyval[0]);
			var val = decodeURIComponent(keyval[1]);
		
			settings[key] = val;
		}
	}
}

function csvStringToArray(params,key)
{
	if( params[key] )	params[key] = params[key].split(",");
}

//Strip out strings that are larger than maxsize
function removeStringsFromArray(thearray,maxsize)
{
	if( thearray instanceof Array )
		for(i = thearray.length-1; i>=0; i-- )
		{
			if(thearray[i].length > maxsize) thearray.splice(i,1);
		}
}


