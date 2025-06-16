<cfoutput>
	<!--- Displayed when no log file is selected --->
	<div class="row no-file-select justify-content-center mt-3">
		<!--- Centered message box with background, padding, and rounded corners --->
		<div class="inner text-center bg-c-secondary rounded-3 col-6 py-4 px-3 mx-1">
			<!--- Icon indicating "no file" state --->
			<i class="bi bi-folder-x fs-1 text-danger mb-3"></i>
			<h3>No file selected</h3>
			<p class="text-white-50">Please select a file to view and analyze data.</p>
			<a href="#baseURL#?site=dataSelect" class="mt-3 btn btn-main" role="button">Go to File selection</a>
		</div>
	</div>
</cfoutput>