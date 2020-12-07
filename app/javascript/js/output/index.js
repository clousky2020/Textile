// 删除记录
$(document).on('click', '.output_remove', function () {
    var id = $(this).parent().find('.id_position')[0].textContent;
    if (confirm("确定删除吗？")) {
        $.ajax({
            type: "delete",
            url: "/outputs/" + id,
            date: {"id": id},
            success: $(this).closest('tr').remove(),
        });
    }
})
// 批量删除记录
$(document).on('click', '#batch_delete', function () {
    var checked_list1 = $(".warning");
    var checked_list2 = checked_list1.children(".id_position");
    var ids = [];
    for (var i = 0; i < checked_list2.length; i++) {
        ids.push(checked_list2[i].textContent);
    }
    if (confirm("确定删除吗？")) {
        $.post("/outputs/delete_list", {ids: ids})
    }
})

$(document).on('click', '#filter', function () {
    var $ti = $("input[type=\"checkbox\"]");
    if ($ti.length > 0) {
        $ti.parent().remove();
        $("#batch_delete").remove();
        $(".warning").removeClass('warning');
    } else {
        var $thr = $('table thead tr');
        var $checkAllTh = $('<th><input type="checkbox" id="checkAll" name="checkAll" /></th>');
        $thr.prepend($checkAllTh);
        var $tbr = $('table tbody tr');
        var $checkItemTd = $('<td><input type="checkbox" name="checkItem" /></td>');
        //每一行都在最前面插入一个选中复选框的单元格
        $tbr.prepend($checkItemTd);

        //添加一个删除的按钮
        $("#filter").after("<a id=\"batch_delete\" href=\"javascript:;\">批量删除</a>")

        //“全选/反选”复选框
        var $checkAll = $thr.find('input');
        $checkAll.on("click", function (event) {
            //将所有行的选中状态设成全选框的选中状态
            $tbr.find('input').prop('checked', $(this).prop('checked'));
            //并调整所有选中行的CSS样式
            if ($(this).prop('checked')) {
                $tbr.find('input').parent().parent().addClass('warning');
            } else {
                $tbr.find('input').parent().parent().removeClass('warning');
            }
            //阻止向上冒泡，以防再次触发点击操作
            event.stopPropagation();
        });
        //点击全选框所在单元格时也触发全选框的点击操作
        $checkAllTh.on("click", function () {
            $(this).find('input').click();
        });

        //点击每一行的选中复选框时
        $tbr.find('input').click(function (event) {
            //调整选中行的CSS样式
            $(this).parent().parent().toggleClass('warning');
            //如果已经被选中行的行数等于表格的数据行数，将全选框设为选中状态，否则设为未选中状态
            $checkAll.prop('checked', $tbr.find('input:checked').length == $tbr.length ? true : false);
            //阻止向上冒泡，以防再次触发点击操作
            event.stopPropagation();
        });
        //点击每一行时也触发该行的选中操作
        $tbr.on("click", function () {
            $(this).find('input').click();
        });
    }
})