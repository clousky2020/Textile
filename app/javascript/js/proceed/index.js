import {set_data, set_title} from "../commont";


$(document).on("turbolinks:load", function () {

    var data = set_data("proceed", "index", "intro");
    var title = set_title(data.controller_name, data.action_name, data.tour_name, data.creator_id);

    if (window.location.pathname == "/proceed") {
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
    function startIntro() {
        var intro = introJs();
        intro.setOptions({
            skipLabel: "暂时跳过",
            nextLabel: '下一步',
            prevLabel: '上一步',
            doneLabel: '完成',
            exitOnOverlayClick: false,
            steps: [
                {
                    intro: "欢迎,这是收款单页面，从客户那里收的款项都可以在这里创建，查找。红色的为未审核单据，绿色为已通过审核的单据,黄色的为已作废的单据"
                },
                {
                    element: '.create_order',
                    intro: "点击进入可以创建新的收款单",
                },
                {
                    element: '#search',
                    intro: "可以输入查询条件，例如单号、客户名、备注等等",
                },
            ]
        });
        intro.start();
        //主动退出的话，在cookie中记录一下，本次访问不弹出引导了
        intro.onbeforeexit(function () {
            Cookies.set(title, true, {path: '/'})
        });
        intro.oncomplete(function () {
            Cookies.remove(title);
            $.post('/introjs', data)
        });
    }

})