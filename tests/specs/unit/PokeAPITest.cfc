component extends="coldbox.system.testing.BaseModelTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();
		super.setup();

        pokemon = createMock("models.Pokemon");
        mockPokemonDao = createEmptyMock("models.DAO.PokemonDao").$("savePokemon", ()=>{});        
        mockPokemonService = createEmptyMock("models.com.cupidmedia.pokemon.PokemonService").$("getPokemon",getPokemon(100));

        pokemon.$property(propertyname = "PokemonDao", mock=mockPokemonDao)
        pokemon.$property(propertyname = "PokemonService", mock = mockPokemonService);

	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {

        describe( " Successful Pokemon data", function() {

            it( "returns the pokemon data and status code 200 after fetching & inserting into database", function() {

				expect( pokemon.getPokemonInfo(100).statusCode ).toBe( '200' );
                expect( pokemon.getPokemonInfo(100).data ).toBe( "Pokemon #pokemon.getPokemonInfo(100).name# with an ID 100 is stored in CupidMedia's pokemon database" );
			} );

		} );

        describe( "Error with invalid inputs", function() {

            it( "returns 404", function() {

                mockPokemonService.$("getPokemon",getPokemon(5555));

				expect( pokemon.getPokemonInfo(5555).statusCode ).toBe( '404' );
                expect( pokemon.getPokemonInfo(5555).data ).toBe( 'Not Found' );
			} );
		} );
    }

    struct private function getPokemon( required numeric pokemonId )
    {
        var apiResponse ={error = false, data = "", statuscode = 0};
        http url="https://pokeapi.co/api/v2/pokemon/#arguments.pokemonId#" method="GET" result="pokeApiResponse";
        if(!pokeApiResponse.responseHeader.Status_Code == 200 || !isJSON(pokeApiResponse.fileContent))
            apiResponse.error = true;

        apiResponse.data = pokeApiResponse.fileContent;
        apiResponse.statusCode = pokeApiResponse.responseHeader.Status_Code;

    return apiResponse;

    }

}