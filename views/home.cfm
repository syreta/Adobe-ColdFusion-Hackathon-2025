<cfscript>
	// Instantiate the log processing service
	cfoLogScope = new lib.LogScope();

	// Initialize the CSV data container
	csvFile = {};

	// Check if a hashed file entry exists in the session and is already parsed
	if ((session['fileHash'] ?? '') != '' && structKeyExists(session, session['fileHash'])) {
		csvFile = session[session['fileHash']];
	}

	// Determine whether a valid, parsed CSV file is available
	hasValidFile = (session['fileHash'] ?? '') != '' && structKeyExists(csvFile, 'csvData');
</cfscript>

<cfoutput>
	<cfif hasValidFile>
		<!--- Show metric cards if a valid file is loaded --->
		<div class="mt-4">
			<cfinclude template="../includes/metricCards.cfm" />
		</div>

		<!--- Show data visualizations --->
		<div class="mt-4">
			<cfinclude template="../includes/graphCards.cfm" />
		</div>
	<cfelse>
		<!--- Fallback: no file has been selected yet --->
		<div class="mt-4">
			<cfinclude template="../includes/noFileSelect.cfm" />
		</div>
	</cfif>
</cfoutput>