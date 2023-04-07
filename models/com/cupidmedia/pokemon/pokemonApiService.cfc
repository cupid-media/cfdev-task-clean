/**
 * pokemonApiService
 *
 * @author Andey.Naren
 * @date 6/4/23
 **/
component accessors=true output=false persistent=false {
	// setter injection get Pokemon API URL
	property name="pokemonApiUrl" inject="coldbox:setting:pokemonApiUrl";

	/**
	 * Get the details of a pokemon by ID
	 * @pokemonId numeric, required
	 * @return struct, containing information about the pokemon with the specified ID
 */

	Struct function getPokemonById(required numeric pokemonId) {

		try {
			// API url
			var apiUrl = "#variables.pokemonApiUrl#/#arguments.pokemonId#";

			var response = {success: false,
							data:'',
							statusCode: ''
							};
				// Send http request and get the response
				http url="#apiUrl#" method="GET" result="httpResponse";

	 			 response.data = httpResponse.fileContent;
	 			 response.statusCode = httpResponse.status_code;

			if( httpResponse.status_code EQ "200" AND isJson(httpResponse.fileContent)){
				 response.success = true ;
				}
			return response;

	    }
	    catch (any e) {
	    	//  log e into logFile or Database.
	    	response.data =  "PokeMon API call failed.#e.message#" ;
	    	return response;
		}
    }


}