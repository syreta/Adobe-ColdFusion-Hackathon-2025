<cfoutput>
	<!--- Main header bar: fixed to top, with flexible spacing and alignment --->
	<header class="d-flex align-items-center position-fixed justify-content-between">
		<!--- Left section: burger menu and file info --->
		<div class="ms-4 col-8 d-flex align-items-center">
			<!--- Hamburger menu icon (for sidebar toggle) --->
			<div class="burger-menue">
				<div></div><div></div><div></div>
			</div>
			<!--- File information display --->
			<div class="fileInfo ms-4">
				<!--- Only show file info if a file is currently selected in the session --->
				<cfif session['filepath'] is not ''>
					File: #encodeForHTML(session['filepath'])#
				</cfif>
			</div>
		</div>

		<div class="pdfbutton col-1">
			<a class="btn btn-main" href="#baseURL#pdf/" target="_blank">
				<i class="bi bi-file-earmark-pdf"></i>
				PDF
			</a>
		</div>

		<!--- Right section: Logo (shown only on smaller screens) --->
		<div class="icon d-block d-lg-none col-4 pe-4">
			<img src="assets/img/logscope_logo_darkmode.svg" class="py-3 img-fluid" alt="LogScope Logo">
		</div>
	</header>
</cfoutput>