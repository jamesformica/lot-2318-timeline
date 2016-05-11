module Gallery {
	"use strict";

	export function Initialise($container: JQuery): void {
		new GalleryScroller($container);
	}

	class GalleryScroller {
		private photoCounter: number = 0;
		private maxPhotos: number;

		private $roller: JQuery;
		private $body: JQuery;
		private $prev: JQuery;
		private $next: JQuery;

		constructor(private $container: JQuery) {
			this.$body = $("body");
			this.$roller = this.$container.find(".ui-roller");
			this.$next = this.$container.find(".ui-move-next");
			this.$prev = this.$container.find(".ui-move-prev");

			this.maxPhotos = Number(this.$roller.data("count")) - 1; // 0 index it

			this.AttachEvents();
			this.ToggleBodyScroll(false);
		}

		private AttachEvents(): void {
			this.$next.click(() => {
				if (this.photoCounter < this.maxPhotos) {
					this.photoCounter++;
					this.MoveRoller();
				}
			});

			this.$prev.click(() => {
				if (this.photoCounter > 0) {
					this.photoCounter--;
					this.MoveRoller();
				}
			});

			this.$container.find(".ui-close").click(() => {
				this.CloseGallery();
			});

			this.$container.click((e) => {
				if ($(e.target).hasClass("gallery")) {
					this.CloseGallery();
				}
			});
		}

		private CloseGallery(): void {
			this.ToggleBodyScroll(true);
			Index.Controller.ToggleGallery(false);
		}

		private MoveRoller(): void {
			this.$roller.css("transform", "translateX(" + -100 * this.photoCounter + "%)");

			this.$prev.toggleClass("disabled", this.photoCounter === 0);
			this.$next.toggleClass("disabled", this.photoCounter === this.maxPhotos);
		}

		private ToggleBodyScroll(scroll: boolean): void {
			this.$body.toggleClass("no-scroll", !scroll);
		}
	}
}