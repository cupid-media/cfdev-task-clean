component extends   ="coldbox.system.testing.BaseTestCase"
{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll() {
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "My :Pokemon RESTFUl Service", function() {
			beforeEach( function( currentSpec ) {
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );
			it( "can handle missing actions", function() {
				prepareMock( getRequestContext() ).$( "getHTTPMethod", "GET" );
				var event    = execute( route = "pokemon/bogus" );
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).tobeTrue();
				expect( response.getStatusCode() ).toBe( 404 );
			} );
			it( "can handle wrong actions", function() {
				prepareMock( getRequestContext() ).$( "getHTTPMethod", "POST" );
				var event    = execute( route = "pokemon/view" );
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).tobeTrue();
				expect( response.getStatusCode() ).toBe( 405 );
			} );
			var requestObj = getPageContext().getRequest();
			var serverName = requestObj.getScheme()&"://"&requestObj.getServerName();
			if(len(requestObj.getServerPort()))
			{
				serverName = serverName&":"&requestObj.getServerPort();
			}
			story( "I want to call pokemon API with valid and invalid Ids", function() {
				given( "a valid ID", function() {
					then( "I will be getting status 200", function() {
						// use 36
						http url="#serverName#/api/pokemon/36" method="GET" result="pokemonResults";
						expect( pokemonResults.statusCode).toBe( '200' );
						expect( DeSerializeJson(pokemonResults.filecontent).POKEMON).toBe( 'Downloaded and stored data for Pokemon with id: 36' );
					} );
				} );
				given( "a Invalid ID", function() {
					then( "I will be getting status 404", function() {
						// use 12313123
						http url="#serverName#/api/pokemon/12313123" method="GET" result="pokemonResults";
						expect( pokemonResults.statusCode).toBe( '404' );
						expect( DeSerializeJson(pokemonResults.filecontent).POKEMON).toBe( 'Not Found' );
					} );
				} );
			} );
		} );
	}

}