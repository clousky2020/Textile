$(document).on("turbolinks:load", function () {
    // 点击check_box直接提交
    $(".setting_status").on("change", function () {
        $(this).parent().submit();
    })
})