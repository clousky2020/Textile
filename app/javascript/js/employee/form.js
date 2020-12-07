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

//检查工号是否在在职员工里重复
$(document).on("change", "#employee_work_id", function () {
    var invalid_employee_work_ids = $("#invalid_employee_work_ids").text();
    var targe = $("#employee_work_id").val();
    console.log(invalid_employee_work_ids);
    if (invalid_employee_work_ids.includes(targe)) {
        $("#work_id_error").removeClass("d-none");
    } else {
        $("#work_id_error").addClass("d-none");
    }
})

//保底工资和基础工资只能选一个填写
$(document).on("change", "#employee_basic_wage", function () {
    var employee_minimun_wage = document.getElementById("employee_minimun_wage");
    var employee_basic_wage = document.getElementById("employee_basic_wage");
    if (employee_basic_wage.value > 0) {
        employee_minimun_wage.setAttribute('disabled', true);
    } else {
        employee_minimun_wage.removeAttribute('disabled');
    }
})
//保底工资和基础工资只能选一个填写
$(document).on("change", "#employee_minimun_wage", function () {
    var employee_minimun_wage = document.getElementById("employee_minimun_wage");
    var employee_basic_wage = document.getElementById("employee_basic_wage");
    if (employee_minimun_wage.value > 0) {
        employee_basic_wage.setAttribute('disabled', true);
    } else {
        employee_basic_wage.removeAttribute('disabled');
    }
})
