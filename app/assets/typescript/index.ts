module Index {
    "use strict";

    export function Initialise($body: JQuery): void {

        var photoCounter = 0;
        var $gallery = $body.find(".ui-gallery");
        var $seePhotos = $body.find(".ui-see-photos");

        $seePhotos.click((e) => {
            var eventID = Number($(e.currentTarget).data("eventid"));

            $.ajax({
                method: "GET",
                url: "/gallery/" + eventID
            }).done((result) => {
                $gallery.html(result);
                photoCounter = 0;
            });
        });

        $body.on("click", ".ui-move-next", () => {
            photoCounter++;
            var $roller = $gallery.find(".ui-roller");
            $roller.css("transform", "translateX(calc(-100% * " + photoCounter + "))");
        });

        $body.on("click", ".ui-move-prev", () => {
            photoCounter--;
            var $roller = $gallery.find(".ui-roller");
            $roller.css("transform", "translateX(calc(-100% * " + photoCounter + "))");

        });

    }
}