component accessors="true" singleton {

    property name="dsn" inject="coldbox:setting:pokemon_db";    

	function init() {
		return this;
	}

   function savePokemon(struct pokemonData){
      try{ 
            var sql = "SELECT ID FROM CUPIDMEDIA_POKEMON.POKEMON  WHERE ID =:ID";
            var params = {ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" }};        
            var pokemon_exists = queryExecute( sql, params, { datasource: dsn.name } );
            
            if(pokemon_exists.recordcount){
                updatePokemon(arguments.pokemonData);
                updatePokemonItems(arguments.pokemonData)
            }
            else{
                createPokemon(arguments.pokemonData);
                createPokemonItem(arguments.pokemonData);
            }
      }catch (any e) {
        // Handle the exception here
        writeOutput("An error occurred while saving the Pokemon: " & e.message);
    }
        
                
    } 
    

    function updatePokemonItems(struct pokemonData) {
        var sql = "SELECT ID FROM CUPIDMEDIA_POKEMON.ITEM WHERE ID = :ID";
        var params = {ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" }};        
        var pokemon_items_exist = queryExecute( sql, params, { datasource: dsn.name } );

        if (pokemon_items_exist.recordCount) {
            // updating the existing records with new values
            var sqlUpdate = "UPDATE CUPIDMEDIA_POKEMON.ITEM SET name = :name, url =:url WHERE ID = :ID";
            var paramsUpdate = {
                ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
                name: { value: arguments.pokemonData.itemName, cfsqltype: "varchar" },
                url: { value: arguments.pokemonData.url, cfsqltype: "varchar" }
            };
            queryExecute( sqlUpdate, paramsUpdate, { datasource: dsn.name } );
        }
        else {
            createPokemonItem(arguments.pokemonData);
        }
    }


	function createPokemon( required struct pokemonData ) {
        var sql = "INSERT INTO CUPIDMEDIA_POKEMON.POKEMON (ID, SPECIES, URL, HEIGHT)
                   VALUES (:ID, :species, :url, :height)";
		var params = {
            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
            species: { value: arguments.pokemonData.species, cfsqltype: "varchar" },
            url: { value: arguments.pokemonData.url, cfsqltype: "varchar" },
            height: { value: arguments.pokemonData.height, cfsqltype: "numeric" }
            };
        
        queryExecute( sql, params, { datasource: dsn.name } );
	}

    function createPokemonItem( required struct pokemonData ) {
        var held_items = arguments.pokemonData.held_items;
        for(pokeMonItem in held_items)
        {   
            var sql = "INSERT INTO CUPIDMEDIA_POKEMON.ITEM (POKEMONID, NAME, URL)
                       VALUES (:ID, :name, :url)";
		    var params = {
                            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
                            name: { value: pokeMonItem.item.name, cfsqltype: "varchar" },
                            url: { value: pokeMonItem.item.url, cfsqltype: "varchar" }
                         };
            
            queryExecute( sql, params, { datasource: dsn.name } );
        }
	}

    function updatePokemon( required struct pokemonData ) {
        var sql = " UPDATE CUPIDMEDIA_POKEMON.POKEMON
                    SET SPECIES = :species,  URL = :url,   HEIGHT = :height
                    WHERE ID =:ID";
		var params = {
                        ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
                        species: { value: arguments.pokemonData.species, cfsqltype: "varchar" },
                        url: { value: arguments.pokemonData.url, cfsqltype: "varchar" },
                        height: { value: arguments.pokemonData.height, cfsqltype: "numeric" }
                    };
        
        queryExecute( sql, params, { datasource: dsn.name } );
	}

    

}