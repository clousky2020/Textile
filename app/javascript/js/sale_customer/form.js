import {str_now_time} from "../commont";

$(document).on("turbolinks:load", function () {
    //把清算时间和清算金额一起删掉
    $("#check_money_time_clear").on("click", function () {
        $("#sale_customer_check_money").val('');
        $("#sale_customer_check_money_time").val(0);
    })
    //填充清算时间
    $("#sale_customer_check_money").on("change", function () {
        $("#sale_customer_check_money_time").val(str_now_time());
    })


})