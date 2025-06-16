<cfscript>
	// Define all charts to render with titles, data source, and chart type
	chartValues = [
		'chTiming' : {
			'title' : 'Response Timing Analysis',
			'data' : [csvFile['timing']],
			'chartType' : 'bar',
		},
		'chMethodCount' : {
			'title' : 'Method Distribution',
			'data' : [csvFile['methodCount']],
			'chartType' : 'ring',
		},
		'chStatusCount' : {
			'title' : 'Status Distribution',
			'data' : [csvFile['statusCount']],
			'chartType' : 'ring',
			'colors' : ['##91b508', '##2211ff', '##ffa500', "ff2211"],
		},
		'chStatusDetailCount' : {
			'title' : 'Detailed Status Distribution',
			'data' : [csvFile['statusDetailCount']],
			'chartType' : 'bar',
		},
		'chDateCount' : {
			'title' : 'Errors and Request by Day',
			'data' : [csvFile['dateCount'], csvFile['dateErrorCount']],
			'chartType' : 'steppedarea',
		},
		'chDateHourCount' : {
			'title' : 'Requests by Hour',
			'data' : [csvFile['dateHourCount']],
			'chartType' : 'line',
		},
		'chBrowserByUserAgent' : {
			'title' : 'Browser By User Agent',
			'data' : [csvFile['userAgent']],
			'chartType' : 'bar',
		},
		'chBotsByUserAgent' : {
			'title' : 'Bots By User Agent',
			'data' : [csvFile['botsByUserAgent']],
			'chartType' : 'bar',
		},
	];
</cfscript>

<cfoutput>
	<!--- Container for all graph cards --->
	<div class="graph-cards row mt-3 loadCharts" data-filehash="#session['fileHash']#">
		<!--- Loop through each chart definition --->
		<cfloop array="#structKeyArray(chartValues)#" item="chartkey">
			<cfset chartItem = chartValues[chartkey] />

			<!--- Responsive chart card container --->
			<div class="col-md-6 col-12 graph-container">
				<div class="inner mx-1 mt-3 rounded-3 py-4 px-3">
					<!--- Chart title --->
					<div class="header">
						#encodeForHTML(chartItem['title'])#
					</div>

					<!--- Chart body: render ColdFusion chart --->
					<div class="body">
						<cfchart
							format="png"
							chartheight="400"
							chartwidth="755"
							type="#chartItem['chartType']#"
							theme="../assets/chartTheme/charttheme.json"
						>
							<!--- Optional custom colour list --->
							<cfset colorList = (structKeyExists(chartItem, 'colors') ? arrayToList(chartItem['colors']) : '') />
							<cfloop array="#chartItem['data']#" item="chartEntry" index="chartIndex">
								<cfset label = '' />
								<cfset color = '##91b508' />
								<cfif arrayLen(chartItem['data']) gt 1>
									<cfset label = chartIndex is 1 ? 'Requests' : 'Errors' />
									<cfset color = chartIndex is 1 ? '##91b508' : '##ff2211' />
								</cfif>
								<cfchartseries colorlist="#colorList#" seriesLabel="#label#" seriescolor="#color#">
									<!--- Loop through all key/value pairs in chart data --->
									<cfset keys = structKeyArray(chartEntry) />
									<cfloop array="#keys#" item="chartInnerValues">
										<cfchartdata item="#chartInnerValues#" value="#chartEntry[chartInnerValues]#">
									</cfloop>
								</cfchartseries>
							</cfloop>
						</cfchart>
					</div>
				</div>
			</div>
		</cfloop>
	</div>
</cfoutput>