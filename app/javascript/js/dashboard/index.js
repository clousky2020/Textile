
$(document).on("turbolinks:load",function () {
    //图表信息查询
    $("#check_order_money").on("click", function () {
        var start_date = $("#start_date").val();
        var end_date = $("#end_date").val();
        $.post("/check_orders_money",
            {
                start_date: start_date,
                end_date: end_date
            }
        )
    });

    $("#check_trade_top").on("click", function () {
        var start_date = $("#start_date").val();
        var end_date = $("#end_date").val();
        $.post("/check_trade_top",
            {
                start_date: start_date,
                end_date: end_date
            }
        )
    });
    $("#check_expense_ratio").on("click", function () {
        var start_date = $("#start_date").val();
        var end_date = $("#end_date").val();
        $.post("/check_expense_ratio",
            {
                start_date: start_date,
                end_date: end_date
            }
        )
    })
});