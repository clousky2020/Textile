$(document).on("turbolinks:load", function () {
    if (Cookies.get("export_sale_customer_tour") && window.location.pathname.match('/sale_customers/\\d+$')) {
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
                element: ".export",
                intro: "这里可以按照特定格式导出该供应商目前为止所有的交易往来，列表是按照订单、付款单的格式排列的。供应商对账单导出也是相同的操作",
            }],
        });
        intro.onexit(function () {
            Cookies.remove("export_sale_customer_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove('export_sale_customer_tour');
        });
    }
})