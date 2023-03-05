component output="false" displayname="Pokemon DAO" accessors="true" {
    public struct function getPokemonDetails(required numeric pokemonId){
        local.sPokemon = {};

        local.qPokemonDetails = queryExecute("SELECT 		pokemon.id, pokemon.species, pokemon.url, pokemon.height
                                        FROM 		CUPIDMEDIA_POKEMON.POKEMON pokemon
                                        WHERE		pokemon.id =:pokemonId", 
                                        {pokemonId = {value = arguments.pokemonId, cfsqltype="cf_sql_integer"}},
                                        {datasource = "pokemon"}
                                    );
        if(local.qPokemonDetails.recordCount){
            local.sPokemon.id        = local.qPokemonDetails.id;
            local.sPokemon.species   = local.qPokemonDetails.species;
            local.sPokemon.url       = local.qPokemonDetails.url;
            local.sPokemon.height    = local.qPokemonDetails.height;
            
            //get pokemon held items if available
            local.pokemonHeldItems      = getPokemonItemDetails(arguments.pokemonId);
            local.sPokemon.heldItems = local.pokemonHeldItems;            
        }

        return local.sPokemon;
	}

     public array function getPokemonItemDetails(required numeric pokemonId){
        local.pokemonHeldItems = [];

        local.qPokemonItemDetails = queryExecute("SELECT 		item.pokemonid, item.name as itemName, item.url as itemUrl
                                            FROM 		CUPIDMEDIA_POKEMON.item item
                                            WHERE		item.pokemonid =:pokemonId", 
                                            {pokemonId = {value = arguments.pokemonId, cfsqltype="cf_sql_integer"}},
                                            {datasource = "pokemon"}
                                    );
        if(local.qPokemonItemDetails.recordCount){
            local.item = [];
            for(local.item in local.qPokemonItemDetails){
                local.item.itemName  = local.qPokemonItemDetails.itemName;
                local.item.itemUrl   = local.qPokemonItemDetails.itemUrl; 
                arrayAppend(local.pokemonHeldItems, local.item)
            }                      
        }

        return local.pokemonHeldItems;
	}

    public function upsertPokemon(required struct pokemonData){
       //If record exist, update, else insert data.
        cfquery( NAME="qPokemon", datasource="pokemon", result="local.result" ) {
            writeOutput("MERGE INTO CUPIDMEDIA_POKEMON.POKEMON (ID, SPECIES, URL, HEIGHT) KEY(ID) 
                VALUES (");
                            cfqueryparam( cfsqltype="cf_sql_integer", value=arguments.pokemonData.id );

                            writeOutput(",");
                            cfqueryparam( cfsqltype="cf_sql_char", value=arguments.pokemonData.species );

                            writeOutput(",");
                            cfqueryparam( cfsqltype="cf_sql_char", value=arguments.pokemonData.url );

                            writeOutput(",");
                            cfqueryparam( cfsqltype="cf_sql_integer", value=arguments.pokemonData.height );

                            writeOutput(")");
        };

        if(arrayLen(arguments.pokemonData.heldItems)){
            for ( i=1 ; i<=ArrayLen(arguments.pokemonData.heldItems) ; i++ ) {
                variables.pokemon.heldItems[i].name = arguments.pokemonData.heldItems[i].item.name;
                variables.pokemon.heldItems[i].url = arguments.pokemonData.heldItems[i].item.url;

                cfquery( NAME="insertitem", datasource="pokemon" ) {
                    writeOutput("MERGE INTO CUPIDMEDIA_POKEMON.ITEM (POKEMONID, NAME, URL) KEY(POKEMONID, NAME) 
                        VALUES (");
                            cfqueryparam( cfsqltype="cf_sql_integer", value=arguments.pokemonData.id );

                            writeOutput(",");
                            cfqueryparam( cfsqltype="cf_sql_char", value=variables.pokemon.heldItems[i].name );

                            writeOutput(",");
                            cfqueryparam( cfsqltype="cf_sql_char", value=variables.pokemon.heldItems[i].url );

                            writeOutput(")");
                }

            }
        }
	}
}