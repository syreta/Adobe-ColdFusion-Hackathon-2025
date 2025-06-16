<cfcontent type="application/pdf">
<cfheader name="Content-Disposition" value="inline; filename=logScope-PDF.pdf">

<cfscript>
	// Initialize the CSV data container
	csvFile = {};

	// Check if a hashed file entry exists in the session and is already parsed
	if ((session['fileHash'] ?? '') != '' && structKeyExists(session, session['fileHash'])) {
		csvFile = session[session['fileHash']];
	}

	// Determine whether a valid, parsed CSV file is available
	hasValidFile = (session['fileHash'] ?? '') != '' && structKeyExists(csvFile, 'csvData');

	// Define all charts to render with titles, data source, and chart type
	if (hasValidFile) {
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
	}
</cfscript>

<cfdocument fontembed="yes" format="PDF">
	<style>
		body {
			font-family: 'Helvetica';
		}
		.headline {
			font-size: 46px;
			text-align: center;
			margin-bottom: 60px;
			margin-top: 400px;
		}
		.chartItem {
			margin-bottom: 25px;
			margin-top: 0;
			padding-top: 0;
		}
		h2 {
			margin-bottom: 0;
			margin-top: 50px;
		}
	</style>

	<cfif hasValidFile>
		<cfdocumentitem type="header">
		</cfdocumentitem>

		<div class="firstPage">
			<h1 class="headline">logScope - PDF Report</h1>
			<img src="../assets/img/logscope_logo_darkmode.png" style="width: 320px; display: block; margin: -10px auto 20px auto;">
		</div>

		<div style="page-break-before: always;"></div>

		<!--- Loop through all charts and render them --->
		<cfloop array="#structKeyArray(chartValues)#" item="chartkey" index="idx">
			<cfset chartItem = chartValues[chartkey] />

			<!--- Chart title --->
			<div>
				<h2><cfoutput>#encodeForHTML(chartItem['title'])#</cfoutput></h3>
			</div>

			<!--- Render chart --->
			<div class="chartItem">
				<cfchart
					format="png"
					chartheight="350"
					chartwidth="755"
					type="#chartItem['chartType']#"
					theme="../assets/chartTheme/chartpdftheme.json"
				>
					<!--- Optional custom colour list --->
					<cfset colorList = (structKeyExists(chartItem, 'colors') ? arrayToList(chartItem['colors']) : '') />
					<cfloop array="#chartItem['data']#" item="chartEntry" index="chartIndex">
						<cfset label = '' />
						<cfset color = '##91b508' />
						<cfif arrayLen(chartItem['data']) gt 1>
							<cfset label = chartIndex is 1 ? 'Requests' : 'Errors'  />
							<cfset color = chartIndex is 1 ? '##91b508' : '##ff2211'  />
						</cfif>
						<cfchartseries colorlist="#colorList#" seriesLabel="#label#" seriescolor="#color#">
							<!--- Loop through all key/value pairs in chart data --->
							<cfloop array="#structKeyArray(chartEntry)#" item="chartInnerValues">
								<cfchartdata item="#chartInnerValues#" value="#chartEntry[chartInnerValues]#">
							</cfloop>
						</cfchartseries>
					</cfloop>
				</cfchart>
			</div>

			<!--- Insert a page break after every 2nd chart, except after the last one --->
			<cfif idx mod 2 eq 0 and idx lt arrayLen(structKeyArray(chartValues))>
				<div style="page-break-before: always;"></div>
			</cfif>
		</cfloop>

		<cfdocumentitem type="footer">
			<div style="text-align: right; padding-bottom: 5px; margin-bottom: 15px; font-family: 'Helvetica'">
				<cfoutput>
					Generated: #dateFormat(now(), "yyyy-mm-dd")# #timeFormat(now(), "HH:mm")#
				</cfoutput>
			</div>
		</cfdocumentitem>
	<cfelse>
		<!--- Fallback content if no valid log file is loaded --->
		<cfoutput>
			<h1 style="color: ##cc0000;">No Log File Selected</h1>
			<p>
				No data could be displayed because no valid log file was selected or processed.
			</p>
			<p>
				Please return to the application and select a file before generating the PDF report.
			</p>
		</cfoutput>
	</cfif>
</cfdocument>