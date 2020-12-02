import {str_now_time} from "../commont";

$(document).on("turbolinks:load", function () {
    //把清算时间和清算金额一起删掉
    $("#check_money_time_clear").on("click", function () {
        $("#purchase_supplier_check_money_time").val('');
        $("#purchase_supplier_check_money").val(0);
    })
    //填充清算时间
    $("#purchase_supplier_check_money").on("change", function () {
        $("#purchase_supplier_check_money_time").val(str_now_time());
    })

    if (Cookies.get("change_purchase_supplier_check_money_time_tour") && window.location.pathname.match('/purchase_suppliers/\\d+/edit$')) {
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
                element: "#check_money",
                intro: "如果到现在为止我们还有1万元还没有付给对方，但是之前的单据因为各种原因无法输入本系统，那这里就填10000，就从这1万元开始计算吧",
            }, {
                element: "#check_money_time",
                intro: "在这时间之前的订单，不管任何状态，都不会记入与该供应商后续的账单计算中了"
            }, {
                element: "#check_money_time_clear",
                intro: "如果不想设置该内容，必须点击这里完全删除以上两点设置，要不然日期删不干净，仍然会当做已经设置好了的进行计算"
            }, {
                intro: "以上通过设置清算金额和清算时间，将以前的订单忽略了，后续与供应商的对账就从这个金额和时间段开始计算。客户的清算金额也是如此设置"
            }],
        });
        intro.onexit(function () {
            Cookies.remove("change_purchase_supplier_check_money_time_tour");
        });
        intro.start().oncomplete(function () {
            Cookies.remove("change_purchase_supplier_check_money_time_tour");
        });
    }

})