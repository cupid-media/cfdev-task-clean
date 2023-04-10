component accessors="true"{

	property name="apiURL" inject="coldbox:setting:apiURL";


	struct function getPokemon(required numeric pokemonid){
		var retStruct = {success=false,apiData=""};
		http url="#apiURL##arguments.pokemonid#" method="GET" result="pokemonResult";
		if(isJSON(pokemonResult.fileContent)){
			var pokemonJsonResult = deserializeJSON(pokemonResult.fileContent);
			retStruct.success = true;
			retStruct.apiData = {};
			retStruct.apiData.height = pokemonJsonResult.height;
			retStruct.apiData.species = pokemonJsonResult.species.name;
			retStruct.apiData.url = pokemonJsonResult.species.url;
			if(isArray(pokemonJsonResult.held_items) && arrayLen(pokemonJsonResult.held_items)){
				retStruct.apiData.itemsArr = pokemonJsonResult.held_items;
			}else{
				retStruct.apiData.itemsArr = [];
			}	
		}
		return retStruct;
	}
}