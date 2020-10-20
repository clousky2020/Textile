// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import jquery from 'jquery';

window.$ = window.jquery = jquery;
import 'bootstrap'
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


$(document).ready(function () {

    //编辑员工页面，如果有新的工种，添加
    $(document).on('click', "#edit_new_work_type", function () {
        $(".work_type_now").addClass("d-none ");
        $(".new_work_type").removeClass("d-none ");
        $(".new_work_type").find("input[name='user[work_type]']").attr('disabled', false);
    })
    $(document).on('click', "#edit_old_work_type", function () {
        $(".work_type_now").removeClass("d-none ");
        $(".new_work_type").addClass("d-none ");
        $(".new_work_type").find("input[name='user[work_type]']").attr('disabled', true);
    })

    //前端校验员工编号
    // $('input[name="user[work_id]"]').change(function () {
    //     var work_id = $(this).val();
    //     var arr = @work_ids;
    //     if $(.inArray(work_id,)) {
    //
    //     }
    // })

})