<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>logScope</title>

	<!--- Ensure required URL and Session variables exist to prevent errors on first load --->
	<cfparam name="url.site" default="home" />
	<cfparam name="session.filePath" default="" />

	<!--- Favicons & PWA metadata --->
	<link rel="icon" type="image/png" href="favicon-96x96.png" sizes="96x96">
	<link rel="icon" type="image/svg+xml" href="favicon.svg">
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">
	<meta name="apple-mobile-web-app-title" content="logScope">
	<link rel="manifest" href="site.webmanifest">

	<!--- Stylesheets (Bootstrap, Icons, DataTables, Custom) --->
	<link rel="stylesheet" href="assets/css/bootstrap.min.css">
	<link rel="stylesheet" href="assets/css/bootstrap-icons.min.css">
	<link rel="stylesheet" href="assets/css/datatables.min.css">
	<link rel="stylesheet" href="assets/css/style.css">

	<cfscript>
		// Dynamically determine the base URL path of the application (e.g. "/hackathon/")
		// This makes all internal links flexible and environment-agnostic
		baseURL = getDirectoryFromPath(cgi.script_name);

		// If a file hash is passed in the URL, try to match it against actual files
		if ((url['file'] ?? '') != '') {
			cacheFile = false;

			files = directoryList(
				application['global']['rootPath'] & 'data',
				false,
				'query',
			);

			for (curFile in files) {
				// Match hashed filename to prevent direct access by name and securely load the file.
				if (hash(curFile['name']) == url['file']) {
					// Save matched file path in session
					session['filePath'] = 'data/#curFile['name']#';
					session['fileHash'] = url['file'];
					cacheFile = true;
					break;
				}
			}

			if (cacheFile) {
				// Instantiate the log processing service
				cfoLogScope = new lib.LogScope();

				// Cache the parsed CSV result under the fileHash key
				session[session['fileHash']] = cfoLogScope.processCSV(
					application['global']['rootPath'] & session['filePath']
				);
			}
		}
	</cfscript>
</head>

<body>
	<!--- Sidebar panel (navigation) --->
	<div id="sidepanel">
		<cfinclude template="includes/sidepanel.cfm" />
	</div>

	<!--- Main content area --->
	<div id="content">
		<!--- Header (logo, current file info, etc.) --->
		<cfinclude template="includes/header.cfm" />

		<!--- Dynamically load main view depending on `url.site` --->
		<div class="mx-4">
			<cfif url['site'] is 'dataSelect'>
				<!--- File selection interface --->
				<cfinclude template="views/dataSelect.cfm" />
			<cfelse>
				<!--- Main dashboard --->
				<cfinclude template="views/home.cfm" />
			</cfif>
		</div>
	</div>

	<!--- JavaScript dependencies --->
	<script src="assets/js/jquery-3.7.1.min.js"></script>
	<script src="assets/js/bootstrap.min.js"></script>
	<script src="assets/js/core.js"></script>
</body>
</html>