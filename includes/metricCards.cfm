<cfscript>
	// Define metric cards to display in the dashboard
	metrics = [
		{
			'name' : 'Total Requests',
			'icon' : 'bi-graph-down',
			'value' : csvFile['timingTotal']['sum'],
		},
		{
			'name' : 'Max Requests',
			'icon' : 'bi-bar-chart',
			'value' : '#csvFile['top']['count']# (#lsDateFormat(csvFile['top']['date'], 'medium')#)',
		},
		{
			'name' : 'Error - 4xx',
			'icon' : 'bi-window-x',
			'value' : csvFile['statusCount']['4xx'] ?? '0',
			'color' : '##ffa500',
		},
		{
			'name' : 'Error - 5xx',
			'icon' : 'bi-database-x',
			'value' : csvFile['statusCount']['5xx'] ?? '0',
			'color' : '##ff2211',
		},
	];

	// Calculate Bootstrap column size per card (max 4 per row)
	colSize = 12;

	if (arrayLen(metrics) > 0) {
		// Ensure minimum col size of 3 (i.e. max 4 cards per row)
		colSize = max(3, int(12 / arrayLen(metrics)));
	}
</cfscript>

<cfoutput>
	<!--- Responsive metric cards container --->
	<div class="metric-cards row">
		<!--- Loop through each metric definition --->
		<cfloop array="#metrics#" index="idx" item="metric">
			<!--- Define column size for each metric card --->
			<div class="entry mb-3 mb-lg-0 col-lg-#colSize# col-md-6 col-12">
				<!--- Card layout: full height with padding, border radius, and spacing --->
				<div class="row h-100 bg-c-secondary rounded-3 my-lg-0 my-2 mx-1 py-4 px-3 justify-content-between align-items-center">
					<!--- Icon section (left) --->
					<div class="col-4 p-0">
						<!--- Display metric icon (Bootstrap Icons) --->
						<i class="bi  #encodeForHTMLAttribute(metric['icon'])#" style="color: #metric['color'] ?? ''#;"></i>
					</div>

					<!--- Text section (right) --->
					<div class="col-8 justify-content-end flex-column d-flex justify-content-end">
						<div class="ms-auto">
							<!--- Metric label --->
							<div class="descr-text text-c-secondary">#encodeForHTML(metric['name'])#</div>
							<!--- Metric value --->
							<div class="value-text">#encodeForHTML(metric['value'])#</div>
						</div>
					</div>
				</div>
			</div>
		</cfloop>
	</div>
</cfoutput>