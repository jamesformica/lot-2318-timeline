module Index {
	"use strict";

	export var Controller: IndexController;

	export function Initialise($container: JQuery): void {
		Controller = new IndexController($container);
	}

	export class IndexController {
		private $gallery: JQuery;
		private $seePhotos: JQuery;

		constructor(private $container: JQuery) {
			this.$gallery = this.$container.find(".ui-gallery");
			this.$seePhotos = this.$container.find(".ui-see-photos");

			this.AttachEvents();
		}

		private AttachEvents(): void {
			this.$seePhotos.click((e) => {
				this.ShowPhotos($(e.currentTarget));
			});
		}

		private ShowPhotos($element: JQuery): void {
			var eventID = Number($element.data("eventid"));

			$.ajax({
				method: "GET",
				url: `/gallery/${eventID.toString()}`
			}).done((result) => {
				this.$gallery.html(result);
				this.ToggleGallery(true);
			});
		}

		ToggleGallery(show: boolean): void {
			this.$gallery.toggleClass("show", show);
		}
	}
}