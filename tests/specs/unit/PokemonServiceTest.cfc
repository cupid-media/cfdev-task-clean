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
		describe( "PokemonService", function() {
			beforeEach( function( currentSpec ) {
				setup();
				model = getInstance( "PokemonService" );
			} );

			it( "can be created", function() {
				expect( model ).toBeComponent();
			} );

			it( "can get a pokemon data by id", function() {
				var oPokemon = model.getPokemonDetails( 34 );
				expect( oPokemon.data.id ).toBe( 34 );
				expect( oPokemon.status ).toBeTrue();
			} );

            it( "can handle repeated calls", function() {
				var oPokemon = model.getPokemonDetails( 34 );
				expect( oPokemon.data.id ).toBe( 34 );
				expect( oPokemon.status ).toBeTrue();
			} );

			it( "can handle invalid id", function() {
                var oPokemon = model.getPokemonDetails( "test" );
				expect( oPokemon.data ).toBe( {} );
				expect( oPokemon.status ).toBeFalse();
			} );
		} );
	}

}
