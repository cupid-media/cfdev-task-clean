/**
 * Cupid Pokemon Handler
 */
component extends="coldbox.system.RestHandler" {
    
	// Injection
	property name="PokeMon" inject="PokeMon";
	property name="restStatusCodes" inject="coldbox:setting:restStatusCodes";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {view : "GET"};

	/**
	 * Retrieve and store a Pokemon
	 *
	 * Maps to GET /api/pokemon/{pokemonID}
	 */
	function view( event, rc, prc ) {

		var validationResult = validate(
            target      = rc,
            constraints = {
                pokemonId    : { required : true, type : "numeric" }
            }
        )

		if ( !validationResult.hasErrors() ) {
            prc.pokeMonResp = PokeMon.get( rc.pokemonId );
			event.renderData( type="JSON", data={pokemon:prc.pokeMonResp.data}, statusCode=prc.pokeMonResp.statusCode);
        } else {
            event.renderData( type="JSON", data={error:validationResult.getAllErrors() }, statusCode=restStatusCodes.bad, statusMessage="Validation error");
        }

	}

	function error( event, rc, prc ) {
		event.renderData( type="JSON", data={error:"An internal error, we are working on this."}, statusCode=restStatusCodes.error);
	}


}
