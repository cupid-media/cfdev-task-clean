component extends="coldbox.system.testing.BaseModelTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();
		// setup the model
		super.setup();

		pokemonMockModel = createMock("models.pokemon");
		pokemonMockApiService = createMock("models.com.cupidmedia.pokemon.pokemonApiService");
		pokemonMockDao = createMock("models.DAO.pokemonDao");

		pokemonMockModel.$property("pokemonApiService", "variables",pokemonMockApiService);
		pokemonMockModel.$property("pokemonDao","variables", pokemonMockDao);

	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "cupidPokemon Service", function() {

			it( "Pokemon Model", function() {
				expect( pokemonMockModel ).toBeComponent();
			} );

			it( "Get Pokemon details with success response", function() {
				var pokemonId = 35;
				var Apiresponse = {success: true,
							data:'{"ID":"35","url":"url","height":"height","species":{"name":"name","url":"url"},"held_items":[]}',
							statusCode: 200
							};

				pokemonMockApiService.$("getPokemonById",Apiresponse);
				pokemonMockDao.$("addOrUpdatePokemonDetails");
				var result = pokemonMockModel.getCupidPokemon(pokemonId);

				expect( result.statusCode ).toBe( 200 );
				expect( result.message ).toBe("I've downloaded and stored data for Pokemon with id: 35");
			} );

			it( "PokemonID does not exists", function() {
				var pokemonId = 353535;
				var Apiresponse = {success: false,
							data:'NOT FOUND',
							statusCode: 404
							};
				// No Need to mock DAO
				pokemonMockApiService.$("getPokemonById",Apiresponse);
				var result = pokemonMockModel.getCupidPokemon(pokemonId);

				expect( result.statusCode ).toBe( 404 );
				expect( result.message ).toBe("NOT FOUND");
			} );

			it( "API Respone Format Error name not specified in Species: exception", function() {
				var pokemonId = 35;
				var Apiresponse = {success: true,
							data:'{"ID":"35","url":"url","height":"height","species":{"url":"url"},"held_items":[]}',
							statusCode: 500
							};
				// No Need to mock DAO
				pokemonMockApiService.$("getPokemonById",Apiresponse);
				var result = pokemonMockModel.getCupidPokemon(pokemonId);

				expect( result.statusCode ).toBe( 500 );
				expect( result.message ).toBe("key [NAME] doesn't exist");
			} );

			it( "API Respone success but data is not Json", function() {
				var pokemonId = 35;
				var Apiresponse = {success: true,
							data:'',
							statusCode: 200
							};
				// No Need to mock DAO
				pokemonMockApiService.$("getPokemonById",Apiresponse);
				var result = pokemonMockModel.getCupidPokemon(pokemonId);

				expect( result.statusCode ).toBe( 200 );
			} );

		} );
	}

}
