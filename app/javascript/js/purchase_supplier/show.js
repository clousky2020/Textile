$(document).on("turbolinks:load", function () {
    if (Cookies.get("export_purchase_supplier_tour")) {
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
                element: ".export",
                intro: "这里可以按照特定格式导出该供应商目前为止所有的交易往来，列表是按照订单、付款单的格式排列的，进去后可以选中日期，再降序排列，会好看点。客户对账单导出也是相同的操作",
            }],
        });
        intro.start().oncomplete(function () {
            Cookies.remove('export_purchase_supplier_tour');
        });
    }


    if (Cookies.get("change_purchase_supplier_check_money_time_tour")) {
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
        intro.start();
    }
})