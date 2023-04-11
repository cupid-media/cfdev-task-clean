component accessors="true" {

	property name="PokemonService" inject="models.com.cupidmedia.pokemon.PokemonService";
    property name="PokemonDao" inject="models.DAO.PokemonDao";



	function init() {
		return this;
	}

    // function accepts pokemonID and returns struct with data and status code  
	struct function getPokemonInfo( required pokemonID ) {
        var pokemon_info =  { 
            "data" : "" ,
            "statusCode" = "",
            "name" = ""
        };
		var apiResponse = PokemonService.getPokemon(arguments.pokemonID);
        pokemon_info.data = apiResponse.data;
        pokemon_info.statusCode = apiResponse.statusCode;
        
		if(apiResponse.error == 'false')
        {   
            var deserialized_data = deserializeJSON(pokemon_info.data);
            var pokemon_data = {
                ID:deserialized_data.ID,
                species:deserialized_data.species.name,
                url:deserialized_data.species.url,
                height:deserialized_data.height,
                held_items:deserialized_data.held_items
            }
            PokemonDao.savePokemon(pokemon_data);
            pokemon_info.data = "Pokemon #pokemon_data.species# with an ID #arguments.pokemonID# is stored in CupidMedia's pokemon database";
            pokemon_info.name = "#pokemon_data.species#";
        }
        return pokemon_info;
	}

}