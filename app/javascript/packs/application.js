// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels");

import jquery from 'jquery';

window.$ = window.jquery = jquery;
import 'bootstrap'

require("jquery-ui");
require("chart.js");

import intro from 'intro.js';

window.introJs = intro;

import Cookies from 'js-cookie/src/js.cookie';

window.Cookies = Cookies;

// import "bootstrap-table";

document.addEventListener('turbolinks:load', () => {
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()
    introJs().showHints();
});

require('../js/tree');

