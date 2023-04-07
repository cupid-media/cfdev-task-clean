/**
 * pokemonDao
 *
 * @author Andey.Naren
 * @date 6/4/23
 **/

<cfcomponent displayname="pokemonDao" output="false">

	<cfproperty name="dsn" inject="coldbox:setting:dsn"/>

	<cffunction name="addOrUpdatePokemonDetails" access="public" returntype="void" output="false">
		<cfargument name="pokemonData" required="true" type="struct" />

		<cfquery name="getPokemonDetails" datasource="#variables.dsn#">
			SELECT ID
			FROM CUPIDMEDIA_POKEMON.POKEMON
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#"/>

		</cfquery>

		<cfif getPokemonDetails.recordcount>
			<cfquery name="updatePokemonDetails" datasource="#variables.dsn#">
				UPDATE
					CUPIDMEDIA_POKEMON.POKEMON
				SET SPECIES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.species#"/>,
					URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.url#"/>,
					HEIGHT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.height#"/>
				WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#"/>
			</cfquery>
		<cfelse>
			<cfquery name="insertPokemonDetails" datasource="#variables.dsn#">
				INSERT
				INTO CUPIDMEDIA_POKEMON.POKEMON
					 (ID, SPECIES, URL, HEIGHT)
				VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.species#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.url#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pokemonData.height#" />
				)
			</cfquery>
		</cfif>
		<cfif !ArrayIsEmpty(arguments.pokemonData.held_items)>
			<cfset addOrUpdatePokemonItemDetails(arguments.pokemonData)>
		</cfif>
	</cffunction>


	<cffunction name="addOrUpdatePokemonItemDetails" access="private" returntype="void" output="false">
		<cfargument name="pokemonData" required="true" type="struct" />

			<cfloop array="#arguments.pokemonData.held_items#" index="currentItem">
				<cfquery name="getPokemonItemDetails" datasource="#variables.dsn#">
					SELECT ID
					FROM CUPIDMEDIA_POKEMON.ITEM
					WHERE POKEMONID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#"/>
					AND NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currentItem.item.name#"/>
				</cfquery>

				<cfif getPokemonItemDetails.recordcount>
					<cfquery name="updatePokemonItemDetails" datasource="#variables.dsn#">
						UPDATE
							CUPIDMEDIA_POKEMON.ITEM
						SET
							URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currentItem.item.url#"/>
						WHERE POKEMONID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#"/>
						AND NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currentItem.item.name#"/>
					</cfquery>
				<cfelse>
					<cfquery name="insertPokemonItemDetails" datasource="#variables.dsn#">
						INSERT
						INTO CUPIDMEDIA_POKEMON.ITEM
							 (POKEMONID, NAME, URL)
						VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pokemonData.id#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentItem.item.name#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentItem.item.url#" />
						)
					</cfquery>
				</cfif>
			</cfloop>

	</cffunction>

</cfcomponent>