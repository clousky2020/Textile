$(document).on("turbolinks:load", function () {
    if (Cookies.get("export_sale_customer_tour")&& window.location.pathname == '/sale_customers') {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "跳过",
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

        intro.start();
    }
})