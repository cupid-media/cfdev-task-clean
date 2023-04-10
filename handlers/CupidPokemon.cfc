/**
 * Cupid Pokemon Handler
 */
component extends="coldbox.system.RestHandler" {


	property name="pokemonService" inject="models:pokemonService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	/**
	 * Retrieve and store a Pokemon
	 *
	 * Maps to GET /api/pokemon/{pokemonID}
	 */
	function getAPokemon( event, rc, prc ) {

		if(!isNumeric(rc.pokemonId)){
			event.getResponse().setData("Validation Failed");
			event.getResponse().setStatusCode(400);
		}else{
			var getPokemon = pokemonService.getPokemon(rc.pokemonId);
			event.getResponse().setData( getPokemon.message );
			if(getPokemon.success){
				event.getResponse().setStatusCode(200);
			}else{
				event.getResponse().setStatusCode(500);
			}
		}
	}


}
