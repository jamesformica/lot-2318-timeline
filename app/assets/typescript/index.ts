module Index {
    "use strict";

    export function Initialise($body: JQuery): void {

        var $gallery = $body.find(".ui-gallery");
        var $seePhotos = $body.find(".ui-see-photos");

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