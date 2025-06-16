component {

	// Name of the application (used for application scope separation)
	this.name = 'hackathonLogScope';
	// Enable client scope (stored per user, usually in cookies or database)
	this.clientmanagement = true;
	// Enable session scope for user sessions
	this.sessionmanagement = true;
	// Set session timeout to 1 hour (days, hours, minutes, seconds)
	this.sessiontimeout = createTimespan(0, 1, 0, 0);
	// Define root path of the application at runtime
	this.webroot = getDirectoryFromPath(getCurrentTemplatePath());
	// Define custom mapping to allow instantiation like: new lib.MyComponent()
	this.mappings = {
		'/lib' : this.webroot & 'lib',
	};

	/**
	 * Runs once when the application starts (first request or restart).
	 * Useful for initializing global paths, settings, caches, etc.
	 */
	function onApplicationStart() {
		// Store global settings in the application scope
		application['global'] = {
			'rootPath': this.webroot,
		};

		return true;
	}

	/**
	 * Runs once per user session.
	 * Useful for initializing session-specific data (e.g., auth state, counters).
	 */
	function onSessionStart() {
		// No session-level setup needed at the moment
	}

	/**
	 * Runs before each request.
	 * Good place for access control, logging, or CSP nonce generation.
	 */
	function onRequestStart() {
		// No request-level logic currently needed
	}

}