component extends="coldbox.system.testing.BaseTestCase" {
	
	/**
	 * Set up the test environment before all tests
	 */
	function beforeAll() {
		super.beforeAll();
		// Perform any necessary setup
	}

	/**
	 * Tear down the test environment after all tests
	 */
	function afterAll() {
		// Perform any necessary teardown
		super.afterAll();
	}

	/**
	 * The test runner
	 */
	function run() {
		describe("Cupid Pokemon RESTful Service", function() {
			
			// Set up the environment before each test
			beforeEach(function(currentSpec) {
				setup();
			});

			/**
			 * Test for missing actions
			 */
			it("handling missing actions", function() {
				prepareMock(getRequestContext()).getHTTPMethod("GET");
				var event = execute(route = "pokemon/page");
				var response = event.getPrivateValue("response");
				expect(response.getError()).toBeTrue();
				expect(response.getStatusCode()).toBe(404);
			});


			/**
			 * Test the Pokemon API with valid and invalid IDs
			 */
			story("Pokemon API call with valid and invalid IDs", function() {

				// Get the server name and port
				var requestObj = getPageContext().getRequest();
				var serverName = requestObj.getScheme() & "://" & requestObj.getServerName();

				if(len(requestObj.getServerPort())) {
					serverName = serverName & ":" & requestObj.getServerPort();
				}

				

				// Test with invalid ID
				given("an invalid ID", function() {
					then("Status: 404", function() {
						http url = "#serverName#/api/pokemon/55555" method = "GET" result = "pokeApiResponse";
						expect(pokeApiResponse.statusCode).toBe('404');
						expect(DeSerializeJson(pokeApiResponse.filecontent).POKEMON).toBe('Not Found');
					});
				});

			});

		});

	}
}
