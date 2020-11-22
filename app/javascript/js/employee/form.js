$(document).on("turbolinks:load", function () {
//编辑员工页面，如果有新的工种，添加
    $(document).on('click', "#edit_new_work_type", function () {
        $(".work_type_now").addClass("d-none ");
        $(".new_work_type").removeClass("d-none ");
        $(".new_work_type").find("input[name='employee[work_type]']").attr('disabled', false);
    })
    $(document).on('click', "#edit_old_work_type", function () {
        $(".work_type_now").removeClass("d-none ");
        $(".new_work_type").addClass("d-none ");
        $(".new_work_type").find("input[name='employee[work_type]']").attr('disabled', true);
    })
})