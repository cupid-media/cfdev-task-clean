component accessors="true"{


	function init() {
		return this;
	}

	struct function getPokemon( required numeric pokemonId ) {
		var apiResponse= {			
			"data" : "" ,
			"statusCode" = "",
			"error" : false
		}

		cfhttp(url="https://pokeapi.co/api/v2/pokemon/#arguments.pokemonId#", method="GET", result="pokeApiResponse");

		if(isJSON(pokeApiResponse.fileContent))
		{
			apiResponse.data = pokeApiResponse.fileContent;
			apiResponse.statusCode = pokeApiResponse.responseHeader.Status_Code;

		}
		else 
		{   
			apiResponse.error = true;
			if(pokeApiResponse.responseHeader.Status_Code== "404")
			{
				apiResponse.data = 'Not Found';	
			}
			apiResponse.statusCode = pokeApiResponse.responseHeader.Status_Code;
		}	   		

		return apiResponse;
	}

}