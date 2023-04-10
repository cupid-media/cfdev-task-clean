/**
 * The base model test case will use the 'model' annotation as the instantiation path
 * and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
 * responsibility to update the model annotation instantiation path and init your model.
 */
component extends="coldbox.system.testing.BaseModelTest"  {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();

		// setup the model
		super.setup();
        pokemonService = createMock("models.pokemonService");
        daoMock = createEmptyMock( "models.pokemonDAO");
        apiMock = createEmptyMock("models.com.cupidmedia.pokemon.pokemonendpoint");
	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "A Pokemon model", function() {
			it( "can be created", function() {
				expect( pokemonService ).toBeComponent();
			});
		});
		describe( "Pass a valid and invalid Pokemon ID and check the resulted Struct", function() {
			it( "valid pokemon id", function() {
				daoMock.$("createorupdatedata",'');
				apiMock.$("getPokemon",{success=true,apiData={height="1",species="test",url="test.com",itemsArr=[]}});
				pokemonService.$property(propertyname="api", mock=apiMock);
				pokemonService.$property(propertyname="dao", mock=daoMock);
				var resultStruct = pokemonService.getPokemon(36);
				expect( resultStruct.success ).toBeTrue();
				expect(resultStruct.message).toBe("I've downloaded and stored data for Pokemon with id: 36")
			});
			it( "invalid pokemon id", function() {
				daoMock.$("createorupdatedata",'');
				apiMock.$("getPokemon",{success=false,apiData="Please check the pokemonid"});
				pokemonService.$property(propertyname="api", mock=apiMock);
				pokemonService.$property(propertyname="dao", mock=daoMock);
				var resultStruct = pokemonService.getPokemon(134256);
				expect( resultStruct.success ).toBeFalse();
				expect(resultStruct.message).toBe("Please check the pokemonid")
			});
		});
	}

}
