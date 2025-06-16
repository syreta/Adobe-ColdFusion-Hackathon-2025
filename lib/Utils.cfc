component {

	/**
	 * Constructor method that initializes the Utils component
	 *
	 * @return Utils Returns the initialized Utils instance
	 */
	public Utils function init() {
		return this;
	}

	/**
	 * Formats a file size from bytes into a human-readable format with appropriate units
	 *
	 * @param fileSize Required numeric value representing the file size in bytes
	 * @return struct Returns a struct containing the converted file size and unit
	 */
	public struct function formatFileSize(
		required numeric fileSize
	) {
		// Default result: raw size in bytes
		var result = {
			'fileSize': fileSize,
			'unit': 'B'
		};
		// Define units for conversion
		var units = ['B', 'KB', 'MB', 'GB', 'TB'];
		// Working copy of the size
		var size = arguments['fileSize'];
		var unitIndex = 1;

		// Loop to convert bytes into next higher unit (e.g., B → KB → MB)
		while (size >= 1024 && unitIndex < arrayLen(units)) {
			size = size / 1024;
			unitIndex++;
		}

		// Final values after conversion
		result['fileSize'] = size;
		result['unit'] = units[unitIndex];

		// Format the output string with 2 decimal places
		result['formatted'] = lsNumberFormat(result['fileSize'], '.99') & ' ' & result['unit'];

		return result;
	}

}