module Index {
    "use strict";

    export function Initialise($container: JQuery): void {
        var $gallery = $container.find(".ui-gallery");
        var $seePhotos = $container.find(".ui-see-photos");

        $seePhotos.click((e) => {
            var eventID = Number($(e.currentTarget).data("eventid"));

            $.ajax({
                method: "GET",
                url: "/gallery/" + eventID
            }).done((result) => {
                $gallery.html(result);
            });
        });
    }
}