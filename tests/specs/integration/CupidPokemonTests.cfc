
/**
 * CupidPokemonTests
 *
 * @author Andey.Naren
 * @date 6/4/23
 **/

component extends="coldbox.system.testing.BaseTestCase" {


	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();

		getWireBox().autowire( this );
		// do your own stuff here
	}

	function afterAll() {
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "cupidpokemon details", function() {
			beforeEach( function( currentSpec ) {
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "Get cupidPokemon details with pokemonId", function() {
				given( "pokemonId is a valid", function() {
					then( "Should return succes response", function() {
						var event = this.get(
							route  = "/api/pokemon/35"
						);
						var response = event.getPrivateValue( "Response" );

						expect( response.getError() ).toBeFalse();
						expect( response.getStatusCode()).toBe( 200 );
						expect( response.getData().apiResponse).toBe( "I've downloaded and stored data for Pokemon with id: 35" );
					} );
				} );

				given( "pokemonId is a valid but calling method is wrong", function() {
					then( "should return method failure", function() {
						var event = this.Post(
							route  = "/api/pokemon/35"
						);
						var response = event.getPrivateValue( "Response" );

						expect( response.getError() ).toBeTrue();
						expect( response.getStatusCode()).toBe( 405 );
						expect( response.getmessages()[1]).toBe( "InvalidHTTPMethod Execution of (getCupidPokemon): POST" );
					} );
				} );
			} );


			story( "Invalid PokemonId", function() {
				given( "pokemonId is a invalid", function() {
					then( "should return Validation Failure message", function() {
						var event = this.get(
							route  = "/api/pokemon/AAA"
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse();
						expect( response.getStatusCode() ).toBe( 400 );
						expect( response.getmessages()[1] ).toBe( "Please correct the errors and retry" );

					} );
				} );

				given( "pokemonId is not exists", function() {
					then( "should return not found from API", function() {
						var event = this.get(
							route  = "/api/pokemon/353535"
						);
						var response = event.getPrivateValue( "Response" );
						var apiResponse  = response.getData().apiResponse;

						expect( response.getError() ).toBeFalse();
						expect( response.getStatusCode()).toBe( 404 );
						expect( response.getData().apiResponse).toBe( "Not Found" );

					} );
				} );
			} );

		} );
	}

}
