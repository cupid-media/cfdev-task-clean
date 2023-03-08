component accessors="true" {

	property name="PokeMonWrapper" inject="PokeMonWrapper";
    property name="PokeMonDao" inject="PokeMonDao";

    

	function init() {
		return this;
	}

    // function accepts pokemonID and returns struct with data and status code  
	struct function get( required numeric pokemonID ) {
        var pokemonResultToReturn =  { 
            "data" : "" ,
            "statusCode" = ""
        };
		var pokemonApiResult = PokeMonWrapper.pokemonDetailsByID(arguments.pokemonID);
        pokemonResultToReturn.statusCode = pokemonApiResult.statusCode;
        pokemonResultToReturn.data = pokemonApiResult.data;
		if(!pokemonApiResult.error)
        {   
            var pokeMonData = deserializeJSON(pokemonApiResult.data);
            var pokeMonCleanData = {
                ID:pokeMonData.ID,
                species:pokeMonData.species.name,
                url:pokeMonData.species.url,
                height:pokeMonData.height,
                held_items:pokeMonData.held_items
            }
            PokeMonDao.pokemonCreateUpdateWithDataCheck(pokeMonCleanData);
            pokemonResultToReturn.data = "Downloaded and stored data for Pokemon with id: #pokeMonData.id#";
        }
        return pokemonResultToReturn;
	}

}
