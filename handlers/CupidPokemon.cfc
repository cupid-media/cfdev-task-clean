/**
 * Cupid Pokemon Handler
 */
component extends="coldbox.system.RestHandler" {

	property name="pokemon" inject="models:pokemon";

	/**
	 * check and store a Pokemon
	 *
	 * Maps to GET /api/pokemon/{pokemonID}
	 */

	public void function getCupidPokemon(event, rc, prc) {

		var result = getValidationManager().validate(
            target      = rc,
            constraints = {
                pokemonId    : { required : true, type : "numeric" }
            }
        )

        // If the validation failed, display an error message and setting response code to 400 (Bad Request)
        if (result.hasErrors()) {
        	event
			.getResponse()
			.setData({"error" : result.getErrors()})
			.setStatusCode(400)
			.addMessage( "Please correct the errors and retry" );
			return;
        } else {
			var response = variables.pokemon.getCupidPokemon(rc.pokemonId);
			event.getResponse().setData({"ApiResponse" : response.message});
			event.getResponse().setStatusCode(response.statusCode);
        }

	}

}
