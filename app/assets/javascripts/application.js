// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require autocomplete-rails
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-editable.min
//= require client_management
//= require tinymce-jquery
//= require jquery_nested_form
//= require_tree .

var CLU_BASE_URLS = {
  crmCaseBaseURL : '/crm/cases/',
  crmConnectionBaseURL : '/crm/connections/',
  taggingTagBaseURL : '/tagging/tags',
  crmStatusesBaseURL : '/crm/statuses/',
  usageUsersBaseURL : '/usage/users/',
  usageNotesBaseURL : '/usage/notes/',
  crmNotesBaseURL : '/crm/notes/',
  crmSystemTasksBaseURL : '/crm/system_tasks/',
  crmBeneficiariesBaseURL : '/crm/beneficiaries/'
}

function hide_role(drop_down_value) {
  if (drop_down_value == '') {
      $('#role').show();
      $('#auto-complete-template').hide();
  }
  else{
    $('#role').hide();
    $('#auto-complete-template').show();
  }
}

function fire_ajax(url, data, type)
{
  $.ajax({
    url: url,
    data: data,
    type: type
  });
}

$(document).on("click","html",function(){
 $('#container-rightbar-nav').hide();
});

$(document).on("click","#container-rightbar-nav",function(e){
  e.stopPropagation();
});
