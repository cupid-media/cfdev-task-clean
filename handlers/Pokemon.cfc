/**
 * Cupid Pokemon Handler
 */
component extends="coldbox.system.RestHandler" {

	property name="Pokemon" inject="Pokemon";


	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {view : "GET"};

	/**
	 * Maps to GET /api/pokemon/{pokemonID}
	 */
	function view( event, rc, prc ) {
		

		// Validate the Pokemon ID for security reasons
		if( NOT isNumeric(rc.pokemonId) OR rc.pokemonId LT 1 ) {	
			event.getResponse().setStatus(400);
			event.getResponse().setData({error="Invalid pokemon ID"});
			return;	
		}
		
		// Validate the Pokemon ID to prevent large numbers /DOS attacks that could cause performance issues / server crash
		if (!reFind("^[0-9]{1,5}$", rc.pokemonId)) {
			event.getResponse().setStatus(400);
			event.getResponse().setData({error="pokemon ID is too large"});
			return;			
		}

            prc.pokemonResp = Pokemon.getPokemonInfo( rc.pokemonId );
			event.renderData( type="JSON", data={pokemon:prc.pokemonResp.data}, statusCode=prc.pokemonResp.statusCode);

			

	}

}