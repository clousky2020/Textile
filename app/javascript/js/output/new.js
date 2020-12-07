// 添加记录
$(document).on("click", "#add_button", function () {
    var output_date = $("#output_date").val();
    var product_specification_id = $("#product_specification").val();
    var product_specification = $("#product_specification").find("option:selected").text();
    var machine_id = $("#machine_id").val();
    var work_id = $("#work_id").val();
    var weight = $("#weight").val();

    var record = '<div class="record row no-gutters">' +
        '<select name="record[output_date][]" ><option value="' + output_date + '">' + output_date + '</option></select>' +
        '<select name="record[product_specification][]" ><option value="' + product_specification_id + '">' + product_specification + '</option></select>' +
        '<select name="record[machine_id][]" ><option value="' + machine_id + '">' + machine_id + '</option></select>' +
        '<select name="record[work_id][]" ><option value="' + work_id + '">' + work_id + '</option></select>' +
        '<select name="record[weight][]" ><option value="' + weight + '">' + weight + '</option></select>' +
        '<button type="button" class="btn btn-default action remove">X</button></div>'
    if (weight != "") {
        $("#outputs_attributes").append(record);
        //重量输入框清零
        $("#weight").val("");
        //机号输入框清零
        $("#machine_id").val("");
        //设置焦点
        $("#machine_id").focus()
        // 更新现在已有的记录数
        change_input_size();
    } else {
        console.log("重量框里没有内容，不能添加");
    }
})

// 删除记录
$(document).on('click', 'button.remove', function () {
    $(this).closest('.record').remove();
    change_input_size();
})


function change_input_size() {
    $("#record_num").text(parseInt($("#outputs_attributes").children().length));
}

// 控制重量框内的数值
$(document).on("keyup blur", "input[name='weight']", function () {
    if ($.trim($(this).val()) == '' || isNaN($(this).val()) || parseInt($(this).val()) <= 0) {
        $(this).val("");
    } else if (parseFloat($(this).val()) > 99.9) {
        $(this).val($(this).val().substr(0, 2));
        $("#weight").html($(this).val().substr(0, 2));
    } else if ($(this).val().length > 4) {
        $(this).val($(this).val().substr(0, 3));
        $("#weight").html($(this).val().substr(0, 3));
    } else
        $("#weight").html($(this).val());
});
// 控制机号框内的数值
$(document).on("keyup blur", "#machine_id", function () {
    if ($.trim($(this).val()) == '' || isNaN($(this).val()) || parseInt($(this).val()) <= 0) {
        $(this).val("");
    } else if (parseInt($(this).val()) > 27) {
        $(this).val($(this).val().substr(0, 1));
        $("#machine_id").html($(this).val().substr(0, 1));
    } else if ($(this).val().length > 2) {
        $(this).val($(this).val().substr(0, 2));
        $("#machine_id").html($(this).val().substr(0, 2));
    } else
        $("#machine_id").html($(this).val());
});

//聚焦在weight框内，按回车可以直接添加
$(document).on('keyup', '#weight', function (event) {
    if (event.keyCode == "13") {
        //回车执行添加
        $('#add_button').click();
    }
});