/**
 * Cupid Pokemon Handler
 */
component extends="coldbox.system.RestHandler" {

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	property name="pokemonService" inject="PokemonService";

	/**
	 * Retrieve and store a Pokemon
	 *
	 * Maps to GET /api/pokemon/{pokemonID}
	 */
	function getAPokemon( event, rc, prc ) {
		local.input = arguments.rc;

		if(structKeyExists(local.input, 'pokemonId')){
			local.response = pokemonService.getPokemonDetails(local.input.pokemonId);

			if(structKeyExists(local.response, 'code')){
				event.getResponse().setError(true);
				event.getResponse().setErrorMessage(local.response.message);
			}
			event.getResponse().setData( local.response.data );
		}
	}

}
