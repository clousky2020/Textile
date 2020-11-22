import {str_now_time} from "../commont";

$(document).on("turbolinks:load", function () {

    //账单日期如果为空，则填入现在的时间
    var bill_time = $("#purchase_orders_bill_time").val();
    if (!bill_time) {
        $("#purchase_orders_bill_time").val(str_now_time());
    }

    // 采购单页面搜索供应商名称自动填充
    $("#purchase_orders_purchase_supplier").autocomplete(
        {source: $('#purchase_orders_purchase_supplier').data('autocomplete-source')},
        {
            mustContain: true
        }
    )
    // 采购单页面搜索原料名称自动填充
    $("#purchase_orders_name").autocomplete(
        {source: $('#purchase_orders_name').data('autocomplete-source')},
        {
            mustContain: true
        }
    )
    // 采购单页面搜索原料规格型号自动填充
    $("#purchase_orders_specification").autocomplete(
        {source: $('#purchase_orders_specification').data('autocomplete-source')},
        {
            mustContain: true,
        }
    )
})