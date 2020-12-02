$(document).on("turbolinks:load", function () {
    if (Cookies.get("proceed_tour") && window.location.pathname == '/proceeds/new') {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
        });
        intro.exit(function () {
            Cookies.remove("proceed_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove("proceed_tour");
        });
    }
})