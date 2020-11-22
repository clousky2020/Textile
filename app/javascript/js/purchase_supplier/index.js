$(document).on("turbolinks:load", function () {
    if (Cookies.get("change_purchase_supplier_check_money_time_tour") || Cookies.get("export_purchase_supplier_tour")) {
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
                intro: "选择一个供应商进入",
            }],
        });
        intro.start();
    }
})