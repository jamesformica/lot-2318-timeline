module Upload {
	"use strict";

	export function Initialise($container: JQuery): void {
		var $deleteEvent = $container.find(".ui-delete-event");

		$deleteEvent.click(() => {
			var result = confirm("Are you sure you want to delete this event?");

			if (result) {
				var eventID = $deleteEvent.data("eventid");

				// send ajax request to delete the event
				$.ajax({
					url: "/delete/" + eventID,
					method: "POST"
				}).done(() => {
					location.href = "/";
				})

			}
		});
	}
}