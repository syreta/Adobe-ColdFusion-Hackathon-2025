component {

	/**
	 * Constructor for the LogScope component.
	 *
	 * @return LogScope Current instance of the component
	 */
	public LogScope function init() {
		return this;
	}

	/**
	 * Parses a space-delimited CSV-style log file and extracts various metrics.
	 *
	 * @param csvPath Full server path to the CSV or log file
	 * @return struct Aggregated data ready for use in charts, tables, and metrics
	 */
	public struct function processCSV(
		required string csvPath
	) {
		// Struct that holds all parsed log entries and aggregated metrics
		var returnStruct = {
			'displayHeader' = ['Date', 'Time', 'IP', 'Method', 'uriStem', 'uriQuery', 'Port', 'Username', 'cIP', 'UserAgent', 'Referer', 'scStatus', 'scSubstatus', 'scWin32Status', 'TimeTaken', ],
		};

		// Configuration for CSV reading
		var csvReadConfig = {
			'header': ['date', 'time', 'ip', 'method', 'uriStem', 'uriQuery', 'sPort', 'username', 'cIP', 'UserAgent', 'Referer', 'scStatus', 'scSubstatus', 'scWin32Status', 'timeTaken', ],
			'commentMarker': '##',
			'delimiter': ' ',
		};

		// Read the log file into an array of structs
		returnStruct['csvData'] = csvRead(
			filepath = arguments['csvPath'],
			outputFormat = 'arrayOfStruct',
			csvformatconfiguration = csvReadConfig
		);

		// Initialize metrics
		var errorCount = {};
		returnStruct['totalRequests'] = arrayLen(returnStruct['csvData']);
		returnStruct['totalBotRequests'] = 0;
		returnStruct['botsByUserAgent'] = {};
		returnStruct['userAgent'] = {};
		returnStruct['statusCount'] = {};
		returnStruct['statusDetailCount'] = {};
		returnStruct['dateCount'] = [:];
		returnStruct['dateHourCount'] = [:];
		returnStruct['dateErrorCount'] = {};
		returnStruct['methodCount'] = {};
		returnStruct['timing'] = {
			'min': -1,
			'max': -1,
			'avg': 0,
		};
		returnStruct['timingTotal'] = {
			'sum': 0,
		};

		// Loop over each log entry to extract metrics
		for (var item in returnStruct['csvData']) {
			// Status group: e.g., "2xx", "4xx"
			var prefix = left(item['scStatus'], 1) & 'xx';
			// Lowercase, trimmed User-Agent
			var ua = lcase(trim(item['UserAgent']));

			// Count grouped HTTP status codes (e.g., 2xx, 4xx)
			incrementCount(returnStruct['statusCount'], prefix);

			// Count exact HTTP status codes (e.g., 200, 404)
			incrementCount(returnStruct['statusDetailCount'], item['scStatus']);

			// Count requests per date
			incrementCount(returnStruct['dateCount'], item['date']);

			// Count requests per hour per date (e.g., 2025-06-01H14)
			incrementCount(returnStruct['dateHourCount'], item['date'] & 'H' & hour(item['time']));
			
			// Count errors per date
			if (arrayFind([4, 5], left(item['scStatus'], 1))) {
				incrementCount(errorCount, item['date']);
			}

			// Count requests per method
			incrementCount(returnStruct['methodCount'], item['method']);

			// Timing statistics (min, max, sum)
			returnStruct['timingTotal']['sum'] += item['timeTaken'];

			if (returnStruct['timing']['min'] == -1 || item['timeTaken'] < returnStruct['timing']['min']) {
				returnStruct['timing']['min'] = item['timeTaken'];
			}

			if (returnStruct['timing']['max'] == -1 || item['timeTaken'] > returnStruct['timing']['max']) {
				returnStruct['timing']['max'] = item['timeTaken'];
			}

			// Bot detection using pattern match on User-Agent.
			// If the UA matches known bot-related keywords, classify as bot.
			// Otherwise, if the UA is not empty, classify it under a simplified browser label.
			if (reFindNoCase('bot|spider|crawler|slurp|yahoo|duckduckbot|bingbot|googlebot|ahrefs|sogou|scrapy|google|inspect|alittle|python|trident|word|excel|outlook|msoffice|facebook|go-http-client|cfschedule|java|curl', ua)) {
				returnStruct['totalBotRequests']++;

				incrementCount(returnStruct['botsByUserAgent'], ua);
			}
			else if (ua != '-') {
				// All non-bot UAs are grouped by browser type (e.g., Chrome, Firefox)
				incrementCount(returnStruct['userAgent'], normalizeUserAgent(ua));
			}
		}

		// Sort dateCount by actual date value (chronologically)
		var sortedDates = structKeyArray(returnStruct['dateCount']);
		arraySort(sortedDates, function(a, b) {
			return compare(createDateTimeFromString(a), createDateTimeFromString(b));
		});

		// Rebuild sorted struct (preserving original values)
		var sortedDateCount = [:];
		for (var date in sortedDates) {
			sortedDateCount[date] = returnStruct['dateCount'][date];
		}
		returnStruct['dateCount'] = sortedDateCount;

		// Sort dateHourCount keys like "2025-04-29H9" using datetime comparison
		var sortedKeys = structKeyArray(returnStruct['dateHourCount']);
		arraySort(sortedKeys, function(a, b) {
			return compare(parseHourKey(a), parseHourKey(b));
		});

		// Rebuild ordered hour-count struct
		var sortedHourCount = [:];
		for (var key in sortedKeys) {
			sortedHourCount[key] = returnStruct['dateHourCount'][key];
		}
		returnStruct['dateHourCount'] = sortedHourCount;

		// Calculate average time taken per request (rounded)
		returnStruct['timing']['avg'] = round(returnStruct['timingTotal']['sum'] / returnStruct['totalRequests']);

		// Determine the date with the highest number of requests
		returnStruct['top']['date'] = arrayReduce(
			structKeyArray(returnStruct['dateCount']),
			function(acc, key) {
				if (arguments['acc'] == '' || returnStruct['dateCount'][arguments['key']] > returnStruct['dateCount'][arguments['acc']]) {
					return arguments['key'];
				}

				return arguments['acc'];
			},
			''
		);
		returnStruct['top']['count'] = returnStruct['dateCount'][returnStruct['top']['date']];

		// Set the error count for each date; default to 0 if no errors were recorded.
		for (var date in returnStruct['dateCount']) {
			returnStruct['dateErrorCount'][date] = errorCount[date] ?: 0;
		}

		return returnStruct;
	}

	/**
	 * Increments a count in the given struct. Initializes if not set.
	 *
	 * @param target Struct to update
	 * @param key Key to increment
	 */
	private void function incrementCount(
		required struct target,
		required string key
	) {
		// If the key doesn't exist, start at 0; then increment
		arguments['target'][arguments['key']] = (arguments['target'][arguments['key']] ?: 0) + 1;
	}

	/**
	 * Normalizes User-Agent strings into recognizable labels (e.g., "Firefox", "Googlebot", etc.)
	 *
	 * @param ua Full User-Agent string
	 * @return string Normalized label
	 */
	private string function normalizeUserAgent(
		required string ua
	) {
		var agent = lcase(arguments['ua']);

		if (reFind('firefox', agent)) return 'Firefox';
		if (reFind('edg|edge', agent)) return 'Edge';
		if (reFind('chrome', agent) && !reFind('edg|edge', agent)) return 'Chrome';
		if (reFind('safari', agent) && !reFind('chrome', agent)) return 'Safari';
		if (reFind('opera|opr', agent)) return 'Opera';

		return 'Other';
	}

	/**
	 * Converts a string in ISO date format (e.g., "2025-05-12") to a ColdFusion datetime object.
	 * Assumes no time component is present and sets time to 00:00:00.
	 *
	 * @param dateStr Date string in ISO format (yyyy-MM-dd)
	 * @return date Parsed datetime object
	 */
	private date function createDateTimeFromString(
		string dateStr
	) {
		return parseDateTime(trim(arguments['dateStr']));
	}

	/**
	 * Parses a string in the format "yyyy-MM-ddHh" into a full date object.
	 * Example: "2025-06-10H14" → {ts 2025-06-10 14:00:00}
	 *
	 * @param key Combined date/hour string
	 * @return date Parsed ColdFusion datetime object
	 */
	private date function parseHourKey(
		string key
	) {
		var parts = listToArray(arguments['key'], 'H');
		var datePart = trim(parts[1]);
		var hourPart = int(parts[2]);

		return createDateTime(year(datePart), month(datePart), day(datePart), hourPart, 0, 0);
	}

}