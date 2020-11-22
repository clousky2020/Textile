$(document).on("turbolinks:load", function () {
    if (Cookies.get("change_machine_tour")) {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "暂时跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
        });
        intro.onexit(function () {
            Cookies.remove("change_machine_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove("change_machine_tour");
        });
    }
})