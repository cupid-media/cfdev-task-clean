component accessors="true" {
	/**
	 * --------------------------------------------------------------------------
	 * Dependency Injections
	 * --------------------------------------------------------------------------
	 */

	property name="api" inject="pokemonendpoint";
	property name="dao" inject="models:pokemonDAO";

	function init(){
		return this;
	}

	struct function getPokemon(required numeric pokemonid){
		var retStruct = {success=false,message=""};
		var apiResponse = api.getPokemon(arguments.pokemonid);
		if(apiResponse.success){
			dao.createorupdatedata(arguments.pokemonid,apiResponse.apiData);
			retStruct.success = apiResponse.success;
			retStruct.message = "I've downloaded and stored data for Pokemon with id: #arguments.pokemonid#";
		}else{
			retStruct.message = "Please check the pokemonid";
		}
		return retStruct;		
	}
}