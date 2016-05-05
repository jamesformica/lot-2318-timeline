module Upload {
	"use strict";

	export function Initialise($container: JQuery): void {
		new Uploader($container);
	}

	class Uploader {
		private $form: JQuery;
		private $deleteEvent: JQuery;
		private $deleteImage: JQuery;
		private eventID: number;

		constructor(private $container: JQuery) {
			this.$form = $container.find("form");
			this.$deleteEvent = $container.find(".ui-delete-event");
			this.$deleteImage = $container.find(".ui-delete-photo");
			this.eventID = Number(this.$form.data("eventid"));

			this.AttachEvents();
		}

		private AttachEvents(): void {
			this.$deleteEvent.click(() => {
				this.DeleteEvent();
			});

			this.$deleteImage.click((e) => {
				this.DeleteImage($(e.currentTarget));
			});
		}

		private DeleteEvent(): void {
			var result = confirm("Are you sure you want to delete this event?");

			if (result) {
				$.ajax({
					url: "/delete/" + this.eventID.toString(),
					method: "POST"
				}).done(() => {
					location.href = "/";
				});
			}
		}

		private DeleteImage($element: JQuery): void {
			var result = confirm("Are you sure you want to delete this image?");

			if (result) {
				$.ajax({
					url: "/deleteimage",
					data: {
						event_id: this.eventID,
						file_name: $element.data("filename")
					},
					method: "POST"
				}).done(() => {
					location.reload();
				});
			}
		}

	}
}