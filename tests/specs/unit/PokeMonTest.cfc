/**
 * The base model test case will use the 'model' annotation as the instantiation path
 * and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
 * responsibility to update the model annotation instantiation path and init your model.
 */
component extends="coldbox.system.testing.BaseModelTest"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();

		// setup the model
		super.setup();

        //create pokemon object
        pokeMon = createMock("models.pokeMon");

        //Mock pokemon Dao
        mockPokemonDao = createEmptyMock("models.DAO.PokeMonDao").$("pokemonCreateUpdateWithDataCheck", ()=>{});
        
        //Mock pokemon wrapper
        mockPokemonWrapper = createEmptyMock("models.com.cupidmedia.pokemon.PokeMonWrapper").$("pokemonDetailsByID",pokemonApiHit(36));
       
        pokeMon.$property(propertyname = "PokeMonDao", mock=mockPokemonDao)
        pokeMon.$property(propertyname = "PokeMonWrapper", mock = mockPokemonWrapper);

	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "Get Pokemon instance", function() {

			it( "can be created", function() {
				expect( pokeMon ).toBeComponent();
			} );
		} );

        describe( "Get Pokemon details with success", function() {

            it( "will success with correct status code 200", function() {

				expect( pokeMon.get(36).statusCode ).toBe( '200' );
                expect( pokeMon.get(36).data ).toBe( 'Downloaded and stored data for Pokemon with id: 36' );
			} );

		} );

        describe( "Get Pokemon details with error", function() {

            it( "will error with not found status code 404", function() {

                mockPokemonWrapper.$("pokemonDetailsByID",pokemonApiHit(2312312));

				expect( pokeMon.get(2312312).statusCode ).toBe( '404' );
                expect( pokeMon.get(2312312).data ).toBe( 'Not Found' );
			} );
		} );
    }

    struct private function pokemonApiHit( required numeric pokemonId )
    {
        var pokemonApiResult ={error = false, data = "", statuscode = 0};
        http url="https://pokeapi.co/api/v2/pokemon/#arguments.pokemonId#" method="GET" result="pokemonResults";
        if(!pokemonResults.responseHeader.Status_Code == 200 || !isJSON(pokemonResults.fileContent))
            pokemonApiResult.error = true;

        pokemonApiResult.data = pokemonResults.fileContent;
        pokemonApiResult.statusCode = pokemonResults.responseHeader.Status_Code;

    return pokemonApiResult;

    }

}
