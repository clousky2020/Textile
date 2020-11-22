$(document).on("turbolinks:load", function () {
    //账面金额改变时，也改变实际金额
    $("#proceed_paper_amount").on("change", function () {
        $("#proceed_actual_amount").val($("#proceed_paper_amount").val());
    })
})