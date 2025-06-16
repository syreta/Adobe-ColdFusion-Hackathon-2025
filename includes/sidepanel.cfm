<cfscript>
	// Define sidebar navigation entries
	sidePanelEntries = [
		{
			'name' : 'Dashboard',
			'link' : '',
			'icon' : 'bi-speedometer2',
			'sitename' : 'Home',
		},
		{
			'name' : 'File Browser',
			'link' : '?site=dataSelect',
			'icon' : 'bi-folder',
			'sitename' : 'dataSelect',
		},
	];
</cfscript>

<cfoutput>
	<!--- Sidebar wrapper: fixed position, 100% viewport height --->
	<div class="sidepanel-inner pt-1 pe-4 vh-100 position-fixed">
		<!--- Logo/header section --->
		<div class="headerElement mx-4 mb-3">
			<a href="#baseURL#">
				<img class="img-fluid" src="assets/img/logscope_logo_darkmode.svg" alt="Logo">
			</a>
		</div>

		<!--- Navigation items container --->
		<div class="sidepanel-Items d-flex flex-column justify-content-between h-100">
			<!--- Loop through each defined sidebar entry --->
			<div>
				<cfloop array="#sidePanelEntries#" index="idx" item="entry">
					<!--- Highlight current entry if it matches the active page --->
					<a href="#baseURL##entry['link']#" class="item<cfif url['site'] == entry['sitename']> active</cfif>">
						<div class="d-flex align-items-center ps-4 py-1">
							<!--- Icon for the menu item (Bootstrap Icons) --->
							<i class="text-secondary-color bi #encodeForHTMLAttribute(entry['icon'])# circle-Icon me-2"></i>
							<!--- Display menu label --->
							<div class="inner-Text text-c-secondary w-max">#encodeForHTML(entry['name'])#</div>
						</div>
					</a>
				</cfloop>
			</div>

			<a href="https://www.syreta.com" target="blank" class="mb-5 pb-4">
				<div class="d-flex align-items-center justify-content-cneter ps-4 py-1">
					<i class="text-secondary-color bi bi-c-circle me-2"></i>
					<div class="inner-Text text-c-secondary w-max">#year(now())# syreta</div>
				</div>
			</a>
		</div>
	</div>
</cfoutput>
