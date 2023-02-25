component extends="coldbox.system.testing.BaseTestCase" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
		super.beforeAll();
	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "Pokemon", function() {
			beforeEach( function( currentSpec ) {
				setup();
				model = getInstance( "Pokemon" );
			} );

			it( "can be created", function() {
				expect( model ).toBeComponent();
			} );
      
			it( "can validate if pokemon id exist in API", function() {
				var pokemon = model.getPokemonProperties( "Rdasf" );
				expect( pokemon).toBeFalse();
			} );

			it( "can check if pokemon already exists in the database", function() {
				var exists = model.checkExist( 35 );
				expect( exists ).toBeTypeOf("boolean");
			});

			it( "can insert/update new pokemon to database", function() {
        var requestResult = model.getPokemonProperties(35);
				var exists = model.checkExist(35);
        if(requestResult)
        {
          if( exists )
          {
            model.updatePokemon();
          }
          else
          {
            model.insertPokemon();
          }
        }
				expect( exists ).toBeTypeOf("boolean");
			});

      story( "I want to call the api with a pokemon id", function() {
				given( "a valid pokemon id", function() {
					then( "I will be receive a response with message and pokemon details", function() {
            var requestResult = model.getPokemonProperties(35);
            var exists = model.checkExist(35);
            if(requestResult)
            {
              if( exists )
              {
                model.updatePokemon();
              }
              else
              {
                model.insertPokemon();
              }
            }

						var response = model.getResponse();
						expect( response ).toHaveKey("pokemon");
					} );
				} );
				given( "invalid pokemon id", function() {
					then( "I will receive a message with Not Found ", function() {
            var pokemon = model.getPokemonProperties( "Rdasf" );
            var response = model.getResponse();
            expect( response.message ).toBe("No result found");
					} );
				} );
			} );
		});
	}

}
