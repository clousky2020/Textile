$(document).on("turbolinks:load", function () {
    if (Cookies.get("purchase_order_tour") && window.location.pathname == '/purchase_orders/new') {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
        });
        intro.onexit(function () {
            Cookies.remove("purchase_order_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove("purchase_order_tour");
        });
    }
})