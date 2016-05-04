module Gallery {
    "use strict";

    export function Initialise($container: JQuery): void {
        var photoCounter = 0;
        var $roller = $container.find(".ui-roller");

        $container.find(".ui-move-next").click(() => {
            photoCounter++;
            $roller.css("transform", "translateX(calc(-100% * " + photoCounter + "))");
        });

        $container.find(".ui-move-prev").click(() => {
            photoCounter--;
            $roller.css("transform", "translateX(calc(-100% * " + photoCounter + "))");
        });

        $container.find(".ui-close").click(() => {
            $container.parent().empty();
        });

        $container.click((e) => {
            if ($(e.target).hasClass("gallery")) {
                $container.parent().empty();
            }
        });
    }
}