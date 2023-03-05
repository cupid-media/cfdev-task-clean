component output="false" displayname="Pokemon Service" accessors="true" hint="I hold methods to get and set information about the pokemon" {
    property name="pokemonDAO" inject="PokemonDAO";

    public struct function getPokemonDetails(pokemonId){
        local.ret = {
            status: true,
            messages: "",
            data: {}
        }

        try {
            if(isNumeric(arguments.pokemonId)){
                local.pokemonDetails = {};
                //send request to 3rd party API to retrieve and store pokemon information
                cfhttp( url="https://pokeapi.co/api/v2/pokemon/#arguments.pokemonId#", result="local.result", method="GET" );
                
                local.response = deserializeJSON(local.result.filecontent);
                local.pokemonDetails.id = local.response.id;
                local.pokemonDetails.height = local.response.height;
                local.pokemonDetails.species = local.response.species.name;
                local.pokemonDetails.url = local.response.species.url;
                
                local.pokemonDetails.heldItems = [];
                if(arrayLen(local.response.held_items)){
                    local.pokemonDetails.heldItems = local.response.held_items;
                }

                //store pokemon details
                local.upsertPokemon = pokemonDAO.upsertPokemon(local.pokemonDetails);

                //retrieve pokemon information
                local.pokemonDetails = pokemonDAO.getPokemonDetails(arguments.pokemonId);
                
                local.ret.data = local.pokemonDetails;
            } else{
                local.ret.status = false;
                local.ret.code = 401; 
                local.ret.message = "Pokemon ID is required. Please specify an ID.";
            }            
        }
        catch (any e){
            local.ret.status = false;
            local.ret.code = 500;
            local.ret.message = e.message;
        }

        return local.ret;
    }
}