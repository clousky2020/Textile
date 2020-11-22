//引导内容发送到后台的data
export function set_data(controller_name, action_name, tour_name) {
    var data = {
        controller_name: controller_name,
        action_name: action_name,
        tour_name: tour_name,
        creator_id: $("#current_user_id").val()
    }
    return data;
}

//保存到cookie的格式
export function set_title(controller_name, action_name, tour_name, creator_id) {
    var title = '';
    title = title.concat(controller_name, "-", action_name, "-", tour_name, "-", creator_id);
    return title;
}

function getNow(s) {
    return s < 10 ? '0' + s : s;
}

export function str_now_time() {
    var myDate = new Date();//获取当前年
    var year = myDate.getFullYear();//获取当前月
    var month = myDate.getMonth() + 1;//获取当前日
    var date = myDate.getDate();
    var h = myDate.getHours();       //获取当前小时数(0-23)
    var m = myDate.getMinutes();     //获取当前分钟数(0-59)
    var now = year + '-' + getNow(month) + "-" + getNow(date) + "T" + getNow(h) + ':' + getNow(m);
    return now
}