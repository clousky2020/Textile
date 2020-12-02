import {set_data, set_title} from "../commont";

$(document).on("turbolinks:load", function () {
// 设定参数
    var data = set_data("dashboard", "index", "intro")
    var title = set_title(data.controller_name, data.action_name, data.tour_name, data.user_id);


//设定首页的引导信息
    function startIntro() {
        var intro = introJs();
        intro.setOptions({
            steps: [{
                intro: "欢迎您的使用,本系统将为您管理生产中产生的各种单据，首先为您介绍主页的各种功能"
            }, {
                element: '#step1',
                intro: "这里是您在本系统中的角色定位，点击本角色的一些介绍，说明了您的主要职责",
                position: 'auto'
            }, {
                element: '#step2',
                intro: "这里存放着需要处理的单据，未处理完成的单据不会记入系统的后续计算中，请尽快处理本部分的内容！",
                position: 'auto'
            }, {
                element: '#step3',
                intro: '快速进入各种常用单据创建的入口',
                position: 'auto'
            }, {
                element: '#step4',
                intro: "在这里可以看到近一星期内的四种单据录入情况，可以点击后直接查看详情",
                position: 'bottom'
            }, {
                element: '#step5',
                intro: '选择时间周期，点击相应的按钮，查看图表数据。注意：只有已经审核过了的单据才会被计算出来！'
            }, {
                element: '#novice_guide',
                intro: '这里是一些常用的操作流程，可以通过这里的操作提示，熟悉本系统'
            }, {
                element: '#step6',
                intro: '如果您忘记了首页的操作，请点击这里重新开启首页的新手引导'
            }]
        });
        intro.setOptions({
            skipLabel: "暂时跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false
        });
        //主动退出的话，在cookie中记录一下，本次访问不弹出引导了
        intro.onexit(function () {
            Cookies.set(title, true, {path: '/'})
        });
        intro.start().oncomplete(function () {
            Cookies.remove(title);
            $.post('/introjs', data)
        });
    }

//只有在首页的时候，检查是不是需要新手引导
    if (window.location.pathname == "/") {
        //检查cookies中是否经历过新手引导了
        var value = Cookies.get(title);
        if (!value) {
            //查询数据库，是否已经做过这个新手引导
            $.post("/introjs/find_attribute", data, function (data) {
                if (!data) {
                    startIntro();
                }
            });
        }
    }

//以下是选择的流程引导

//付款单的新手引导
    $("#expense_tour").on("click", function () {
        Cookies.set("expense_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                element: '#new_expense',
                intro: "开始创建一张付款单吧"
            }],
            exitOnOverlayClick: false
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/expenses/new"
        });
    });
//收款单的新手引导
    $("#proceed_tour").on("click", function () {
        Cookies.set("proceed_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                element: '#new_proceed',
                intro: "开始创建一张收款单吧",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/proceeds/new"
        });
    });
//采购单的新手引导
    $("#purchase_order_tour").on("click", function () {
        Cookies.set("purchase_order_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                element: '#new_purchase_order',
                intro: "开始创建一张采购单吧",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/purchase_orders/new"
        });
    });
//销售单的新手引导
    $("#sale_order_tour").on("click", function () {
        Cookies.set("sale_order_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                element: '#new_sale_order',
                intro: "开始创建一张销售单吧",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/sale_orders/new"
        });
    });
//改机记录单的新手引导
    $("#change_machine_tour").on("click", function () {
        Cookies.set("change_machine_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                element: '#new_change_machine',
                intro: "开始创建一张改机单吧",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/change_machines/new"
        });
    });
//为供应商设置初始的对账金额
    $("#change_purchase_supplier_check_money_time_tour").on("click", function () {
        Cookies.set("change_purchase_supplier_check_money_time_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                intro: "如果供应商以前的订单遗失了没有记录进去，那金额不就是错误的了！为其设定一个初始的清算金额吧。这里我们拿供应商来练习一下，客户的清算金额也是同样操作",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/purchase_suppliers"
        });
    });
//导出供应商的对账单
    $("#export_sale_customer_tour").on("click", function () {
        Cookies.set("export_sale_customer_tour", true, {path: '/'});
        var intro = introJs();
        intro.setOptions({
            steps: [{
                intro: "需要对账了？只用一个按键就能导出特定格式的对账单了",
            }],
            exitOnOverlayClick: false,
        });
        intro.setOption('doneLabel', '跳转到页面').start().oncomplete(function () {
            window.location.href = "/sale_customers"
        });
    });
})