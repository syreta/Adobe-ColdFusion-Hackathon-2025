<cfscript>
	// Get a list of all files from the /data directory as a query
	files = directoryList(
		application['global']['rootPath'] & 'data',
		false,
		'query',
	);

	// Instantiate the utility class (used to format file sizes)
	cfoUtils = new lib.Utils();
</cfscript>

<cfoutput>
	<!--- File selection component --->
	<div class="file-select row mt-3">
		<div class="row">
			<!--- Table container with background, padding, and rounded corners --->
			<div class="inner bg-c-secondary rounded-3 col-12 py-4 px-3 mx-1">
				<table>
					<thead>
						<tr>
							<th>Filename</th>
							<th>Filesize</th>
							<th>Last Modified</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<!--- Loop through each file entry --->
						<cfloop query="files">
							<!--- Format the file size into KB/MB/GB etc. --->
							<cfset fileSize = cfoUtils.formatFileSize(files.size) />
							<!--- Determine whether this file is currently selected (from session) --->
							<cfset isSelected = (session['filePath'] ?? '') != '' && listLast(session['filePath'], '/') == files.name />
							<tr<cfif isSelected> class="bg-c-highlight highlight"</cfif>>
								<td>#encodeForHTML(files.name)#</td>
								<td>#encodeForHTML(fileSize['formatted'])#</td>
								<td>#lsDateTimeFormat(files.dateLastModified, 'medium')#</td>
								<td class="text-center"><a class="btn btn-main mx-auto <cfif isSelected>disabled</cfif>" href="#baseURL#?file=#hash(files.name)#">Select File</a></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</cfoutput>