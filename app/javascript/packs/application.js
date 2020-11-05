// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import jquery from 'jquery';
import 'bootstrap'

window.$ = window.jquery = jquery;
require("jquery-ui")
require("chart.js")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// $(document).ready(function () {
//     $('[data-toggle="tooltip"]').tooltip();
//
//     // 采购单页面搜索供应商名称自动填充
//     $("#purchase_orders_purchase_supplier").autocomplete(
//         {source: $('#purchase_orders_purchase_supplier').data('autocomplete-source')},
//         {
//
//             mustContain: true
//         }
//     )
//     // 采购单页面搜索原料名称自动填充
//     $("#purchase_orders_name").autocomplete(
//         {source: $('#purchase_orders_name').data('autocomplete-source')},
//         {
//             mustContain: true
//         }
//     )
//     // 采购单页面搜索原料规格型号自动填充
//     $("#purchase_orders_specification").autocomplete(
//         {source: $('#purchase_orders_specification').data('autocomplete-source')},
//         {
//             mustContain: true,
//         }
//     )
//     // 付款单页面搜索交易方自动填充
//     $("#expense_counterparty").autocomplete(
//         {source: $('#expense_counterparty').data('autocomplete-source')},
//         {
//
//             mustContain: true,
//         }
//     )
//     // 付款单页面搜索类别自动填充
//     $("#expense_expense_type").autocomplete(
//         {source: $('#expense_expense_type').data('autocomplete-source')},
//         {
//
//             mustContain: true,
//         }
//     )
//     //销售单页面select选择产品型号规格后，填充下面的产品品名
//     $("#sale_orders_specification").on("change", function () {
//         $.post("/product/get_options", {id: this.value})
//     }).change();
//     // 销售单页面搜索客户名称自动填充
//     $("#sale_orders_sale_customer").autocomplete(
//         {source: $('#sale_orders_sale_customer').data('autocomplete-source')},
//         {
//
//             mustContain: true
//         }
//     )
//
// });
