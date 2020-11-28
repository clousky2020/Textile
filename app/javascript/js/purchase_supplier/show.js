$(document).on("turbolinks:load", function () {
    if (Cookies.get("change_purchase_supplier_check_money_time_tour_show")) {
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
                element: ".edit-link",
                intro: "点击进入编辑页面",
            }],
        });
        intro.onexit(function () {
            Cookies.remove("change_purchase_supplier_check_money_time_tour_show");
        });
        intro.start().oncomplete(function () {
            Cookies.remove('change_purchase_supplier_check_money_time_tour_show');
            Cookies.set('change_purchase_supplier_check_money_time_tour_edit');
        });
    }
})