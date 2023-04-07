
/**
 * pokemon
 *
 * @author Andey.Naren
 * @date 6/4/23
 **/
component accessors="true" output=false persistent=false  {

	property name="pokemonDao" inject="models.DAO:pokemonDao";
	property name="pokemonApiService" inject="models.com.cupidmedia.pokemon:pokemonApiService";


	Struct function getCupidPokemon(required numeric pokemonID) {
		var result = {message : '',
					  statusCode: 500
					  	};
		try {
			var pokemonDetails = variables.pokemonApiService.getPokemonById(arguments.pokemonId);
				result.statusCode = pokemonDetails.statusCode;
				if (pokemonDetails.success AND isJson(pokemonDetails.data)){
					var data = DESERIALIZEJSON(pokemonDetails.data);
					var pokemonData = {
			                ID:data.ID,
			                url:data.species.url,
			                height:data.height,
			                species:data.species.name,
			                held_items:data.held_items
			            }

				    // Call the DAO method to store or update.
					variables.pokemonDao.addOrUpdatePokemonDetails(pokemonData);
					 result.message = "I've downloaded and stored data for Pokemon with id: #arguments.pokemonId#";
				} else{
					result.message = pokemonDetails.data;
				}
				return result;
		 	}
		 	catch (any e) {
		 		//we can add specific logging for pokemon API call in log file or log DataBase, for now just returing error message.
				 result.message = e.message;
				 result.statusCode = 500;
				 return result;
			}
	}
}
