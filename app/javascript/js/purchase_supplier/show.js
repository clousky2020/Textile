$(document).on("turbolinks:load", function () {
    if (Cookies.get("change_purchase_supplier_check_money_time_tour") && window.location.pathname.match('/purchase_suppliers/\\d+$')) {
        console.log("匹配到了");
        var intro = introJs();
        intro.setOptions({
            skipLabel: "结束",
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
        intro.start();
    }
})