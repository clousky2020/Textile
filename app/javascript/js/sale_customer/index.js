$(document).on("turbolinks:load", function () {
    if (Cookies.get("export_sale_customer_tour_index")) {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "暂时跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
        });
        intro.setOptions({
            steps: [{
                intro: "选择一个客户进入",
            }],
        });
        intro.onexit(function () {
            Cookies.remove("export_sale_customer_tour_index");
        });
        intro.start().oncomplete(function () {
            Cookies.remove('export_sale_customer_tour_index');
            Cookies.set("export_sale_customer_tour_show", true, {path: '/'});
        });
    }
})