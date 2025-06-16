// Wait for the DOM to be fully loaded
$(document).ready(function () {
	// Initialize sidebar toggle behavior (for mobile view)
	initSidePanel();
});

// Handles responsive sidebar behavior and hamburger menu toggle
function initSidePanel() {
	// Toggle side panel when burger menu is clicked
	$('.burger-menue').click(function (e) {
		e.preventDefault();

		$('.sidepanel-inner').toggleClass('closed');
	});

	// Collapse side panel on load for mobile viewports
	if (window.innerWidth <= 991) {
		$('.sidepanel-inner').addClass('closed');
	}

	// Re-check on window resize (e.g., rotate phone)
	$(window).resize(function () {
		if (window.innerWidth <= 991) {
			$('.sidepanel-inner').addClass('closed');
		}
	});
}