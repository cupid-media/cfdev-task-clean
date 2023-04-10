<cfcomponent>

	<cfproperty name="dsn" inject="coldbox:setting:dsn">

	<cffunction name="init">
		<cfreturn this/>
	</cffunction>

	<cffunction name="createorupdatedata" access="public" hint="this function is used insert or update the data in the database ">
		<cfargument name="pokemonid" required="true" type="numeric">
		<cfargument name="apirespdata" required="true" type="struct">

		<cfquery name="getpokemon" datasource="#dsn#">
			SELECT * FROM CUPIDMEDIA_POKEMON.POKEMON WHERE ID = <cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif not getpokemon.recordcount>
			<cfquery name="insertpokemon" datasource="#dsn#">
				INSERT INTO CUPIDMEDIA_POKEMON.POKEMON (ID, SPECIES, URL, HEIGHT)
				VALUES (<cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.apirespdata.species#" cfsqltype="cf_sql_varchar">, 
						<cfqueryparam value="#arguments.apirespdata.url#" cfsqltype="cf_sql_varchar">, 
						<cfqueryparam value="#arguments.apirespdata.height#" cfsqltype="cf_sql_integer">)
			</cfquery>
		<cfelse>
			<cfquery name="updatepokemon" datasource="#dsn#">
				UPDATE CUPIDMEDIA_POKEMON.POKEMON 
				SET SPECIES = <cfqueryparam value="#arguments.apirespdata.species#" cfsqltype="cf_sql_varchar">,
					URL = <cfqueryparam value="#arguments.apirespdata.url#" cfsqltype="cf_sql_varchar">,
					HEIGHT = <cfqueryparam value="#arguments.apirespdata.height#" cfsqltype="cf_sql_integer">
				WHERE ID = <cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<cfif isArray(arguments.apirespdata.itemsArr) and arrayLen(arguments.apirespdata.itemsArr)>
			<cfloop from="1" to="#arrayLen(arguments.apirespdata.itemsArr)#" index="i">
				<cfquery name="getpokemonitems" datasource="#dsn#">
					select * from CUPIDMEDIA_POKEMON.ITEM where pokemonid = <cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">
					and name = <cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.name#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif not getpokemonitems.recordcount>
					<cfquery name="inspokemonitems" datasource="#dsn#">
						insert into CUPIDMEDIA_POKEMON.ITEM (pokemonid, name, url)
						values 
						(
							<cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.name#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.url#" cfsqltype="cf_sql_varchar">
						) 
					</cfquery>
				<cfelse>
					<cfquery name="updatepokemonitems" datasource="#dsn#">
					update CUPIDMEDIA_POKEMON.ITEM
						set name = <cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.name#" cfsqltype="cf_sql_varchar">,
						url = <cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.url#" cfsqltype="cf_sql_varchar">
						where pokemonid = <cfqueryparam value="#arguments.pokemonid#" cfsqltype="cf_sql_integer">
						and name = <cfqueryparam value="#arguments.apirespdata.itemsArr[i].item.name#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

</cfcomponent>