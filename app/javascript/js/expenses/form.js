$(document).on("turbolinks:load", function () {
// 付款单页面搜索交易方自动填充
    $("#expense_counterparty").autocomplete(
        {source: $('#expense_counterparty').data('autocomplete-source')},
        {
            minChars: 0,
            mustContain: true,
        }
    );
// 付款单页面搜索类别自动填充
    $("#expense_expense_type").autocomplete(
        {source: $('#expense_expense_type').data('autocomplete-source')},
        {
            minChars: 0,
            mustContain: true,
        }
    );
//账面金额改变时，也改变实际金额
    $("#expense_paper_amount").on("change", function () {
        $("#expense_actual_amount").val($("#expense_paper_amount").val());
    });
})