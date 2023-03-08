component accessors="true"{

    property name="PokemonApi" inject="coldbox:setting:PokemonApi";
	property name="restStatusCodes" inject="coldbox:setting:restStatusCodes";

	function init() {
		return this;
	}

	//Function expects pokemonID to be passed and returns status code and data
	struct function pokemonDetailsByID( required numeric pokemonId ) {
		var pokemonApiResult= {
			"error" : false,
			"data" : "" ,
			"statusCode" = ""
		}
		http url="#PokemonApi.url##arguments.pokemonId#" method="GET" result="pokemonResults";
		if(pokemonResults.responseHeader.Status_Code != restStatusCodes.ok || !isJSON(pokemonResults.fileContent))
		{
			pokemonApiResult.error = true;
			if(restStatusCodes.notfound == pokemonResults.responseHeader.Status_Code)
			{
				pokemonApiResult.data = 'Not Found';	
			}
		}
		else 
		{ 
			pokemonApiResult.data = pokemonResults.fileContent;
		}	   
		pokemonApiResult.statusCode = pokemonResults.responseHeader.Status_Code;
		return pokemonApiResult;
	}

}
