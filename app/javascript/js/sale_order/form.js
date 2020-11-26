import {str_now_time} from "../commont";

$(document).on("turbolinks:load", function () {
    //账单日期如果为空，则填入现在的时间
    var bill_time = $("#sale_orders_bill_time").val();
    if (!bill_time) {
        $("#sale_orders_bill_time").val(str_now_time());
    }
    //销售单页面select选择产品型号规格后，填充下面的产品品名
    $("#sale_orders_specification").on("change", function () {
        $.post("/products/get_options", {id: this.value})
    }).change();
    // 销售单页面搜索客户名称自动填充
    $("#sale_orders_sale_customer").autocomplete(
        {source: $('#sale_orders_sale_customer').data('autocomplete-source')},
        {
            mustContain: true
        }
    )
})
