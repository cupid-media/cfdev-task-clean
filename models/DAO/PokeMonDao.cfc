component accessors="true" singleton {

	// Dependency Injection
    property name="dsn" inject="coldbox:setting:pokemon";

	function init() {
		return this;
	}

    // function check if record exists and update or insert data accordingly
    function pokemonCreateUpdateWithDataCheck(required struct pokemonData)
    {
        var params = {
            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" }
        };
        var sql = "SELECT ID FROM CUPIDMEDIA_POKEMON.POKEMON  WHERE ID =:ID";
        var qryPokemonExists = queryExecute( sql, params, { datasource: dsn.name } );
        //if record exists update main table and delete from items
        if(qryPokemonExists.recordcount)
        {
            updatePokemon(arguments.pokemonData);
            sql = "DELETE FROM CUPIDMEDIA_POKEMON.ITEM WHERE ID =:ID";
            queryExecute( sql, params, { datasource: dsn.name } );
        }
        else
        {
            createPokemon(arguments.pokemonData);
        }
        // insert only if we have items
        if(!ArrayIsEmpty(arguments.pokeMonData.held_items))
                createPokemonItem(arguments.pokemonData);
    }

	function createPokemon( required struct pokemonData ) {
		var params = {
            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
            species: { value: arguments.pokemonData.species, cfsqltype: "varchar" },
            url: { value: arguments.pokemonData.url, cfsqltype: "varchar" },
            height: { value: arguments.pokemonData.height, cfsqltype: "numeric" }
            };
        var sql = "INSERT INTO CUPIDMEDIA_POKEMON.POKEMON (ID, SPECIES, URL, HEIGHT)
                   VALUES (:ID, :species, :url, :height)";
        queryExecute( sql, params, { datasource: dsn.name } );
	}

    function updatePokemon( required struct pokemonData ) {
		var params = {
            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
            species: { value: arguments.pokemonData.species, cfsqltype: "varchar" },
            url: { value: arguments.pokemonData.url, cfsqltype: "varchar" },
            height: { value: arguments.pokemonData.height, cfsqltype: "numeric" }
            };
        var sql = "UPDATE CUPIDMEDIA_POKEMON.POKEMON
                    SET 
                        SPECIES = :species,
                        URL = :url,
                        HEIGHT = :height
                    WHERE ID =:ID";
        queryExecute( sql, params, { datasource: dsn.name } );
	}

    function createPokemonItem( required struct pokemonData ) {
        var pokemonItemsarr = arguments.pokemonData.held_items;
        for(pokeMonItem in pokemonItemsarr)
        {
		    var params = {
            ID: { value: arguments.pokemonData.ID, cfsqltype: "numeric" },
            name: { value: pokeMonItem.item.name, cfsqltype: "varchar" },
            url: { value: pokeMonItem.item.url, cfsqltype: "varchar" }
            };
            var sql = "INSERT INTO CUPIDMEDIA_POKEMON.ITEM (POKEMONID, NAME, URL)
		               VALUES (:ID, :name, :url)";
            queryExecute( sql, params, { datasource: dsn.name } );
        }
	}

}
