$(document).on("turbolinks:load", function () {
    if (Cookies.get("expense_tour")&&window.location.pathname=='/expenses/new') {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
        });
        intro.onexit(function () {
            Cookies.remove("expense_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove("expense_tour");
        });
    }
})