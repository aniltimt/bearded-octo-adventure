var addUserContactInfo = function(url){
  var userId = $('#usage-user-id').val();
  $.ajax({
    url: url,
    data: { user_id: userId },
    type: 'get',
    success: function(data) {
      $('#container-contact-info-modal-pop-up').modal({show:true});
      $('#container-contact-info-modal-pop-up .modal-body').html(data)
    }
  });
}

var updateUserContactInfo = function(url, data, type){
  var userId = $('#usage-user-id').val();
  $.ajax({
    url: url,
    data: data,
    type: type,
    success: function(data) {
      $("#container-contact-info-modal-pop-up").modal('hide');
      fire_ajax('/usage/users/personal?user_id='+userId, {}, 'get');
    },
    error: function(data) {
    }
  });
}

$(document).on('change', 'input.field_set_premium_limit', function() {
  var params_data = { 'agent_field_set' : {'premium_limit' : $(this).val()} };
  url = "/usage/users/"+$(this).data('id')+"/update_agent_field_set"
  fire_ajax(url, params_data, 'put');
});

$(document).on("change", 'input.ldw_premium_limit, input.ldw_weight', function() {
  var data = {};
  data[$(this).attr("name")] = $(this).val();
  url = '/usage/lead_distribution_weights/'+$(this).data('id'),
  fire_ajax(url, data, 'put');
});

$(document).on("click", '.permission-user-select-event.ajax', function() {
  var box = $(this).attr('data-box-id');
  if (box==="4") { return };
  var data = { 'user_id': $(this).attr('data-user-id'),
               'container_id': 'permission-box' + box,
               'box': box
             }
  url = CLU_BASE_URLS.usageUsersBaseURL + 'permissions',
  fire_ajax(url, data, 'get');
});

$(document).on("click", '.agency-user-select-event.ajax', function() {
  var box = $(this).attr('data-box-id');
  if (box==="4") { return };
  var data = { 'user_id': $(this).attr('data-user-id'),
               'container_id': 'index-box' + box,
               'box': box
             }
  url = CLU_BASE_URLS.usageUsersBaseURL,
  fire_ajax(url, data, 'get');
});

$(document).on("click", '.make-user-parent.ajax', function() {
  var data = { 'user_id': $(this).attr('data-user-id'),
               'container_id': 'permissions_boxes',
               'box': 1
             }
  url = CLU_BASE_URLS.usageUsersBaseURL + 'permissions',
  fire_ajax(url, data, 'get');
});

$(document).on("click", '.make-user-agency-parent.ajax', function() {
  var data = { 'user_id': $(this).attr('data-user-id'),
               'container_id': 'agency_users_boxes',
               'box': 1
             }
  url = CLU_BASE_URLS.usageUsersBaseURL,
  fire_ajax(url, data, 'get');
});

$(document).on("change", '#select_users_for_permission', function() {
  var data = { 'user_id': $(this).val(),
               'container_id': 'permissions_boxes',
               'box': 1
             }
  url = CLU_BASE_URLS.usageUsersBaseURL + 'permissions',
  fire_ajax(url, data, 'get');
});

$(document).on("change", '#select_agency_users_for_agency', function() {
  var data = { 'user_id': $(this).val(),
               'container_id': 'agency_users_boxes',
               'box': 1
             }
  url = CLU_BASE_URLS.usageUsersBaseURL,
  fire_ajax(url, data, 'get');
});

$(document).on("click", '.permissions-users-select-checkbox', function() {
  var boxID = $(this).attr('data-box-id');
  var userCheckBoxes = '.permissions-user-checkbox'+boxID;
  $(userCheckBoxes+':not(:checked)').click();
});

$(document).on('click', '#update-users-permissions.ajax', function(){
  var ids = [];
  $(".select-checkbox:checked").each(function(){
    ids.push($(this).attr("data-user-id"));
  });
  if (ids.length === 0) {
    alert('Please select at least one user to set permissions');
    return;
  }
  $.ajax({
    url: CLU_BASE_URLS.usageUsersBaseURL + 'update_permissions',
    data: $("#users-privilages-permissions").serialize() + ("&ids="+ids.join(",")),
    type: 'post',
    success: function(data) {
    }
  });
});

$(document).on('click', '.button-search-users.ajax', function(){
  var boxID = $(this).attr('data-box-id');
  var search = $('#input-search-users'+boxID).val();
  if (search.length===0) { return; }
  $.ajax({
    url: CLU_BASE_URLS.usageUsersBaseURL + 'search_users',
    data: { q: search, box: boxID },
    type: 'get'
  });
});

$(document).on('click', '.button-search-agency-users.ajax', function(){
  var boxID = $(this).attr('data-box-id');
  var search = $('#input-search-users'+boxID).val();
  if (search.length===0) { return; }
  $.ajax({
    url: CLU_BASE_URLS.usageUsersBaseURL + 'search_agency_users',
    data: { q: search, box: boxID },
    type: 'get'
  });
});

$(document).on("click","#add-usage-user-phone.ajax",function(){
  addUserContactInfo('/phone/new/');
});

$(document).on('click', '#submit-usage-user-phone-form.ajax', function(e){
  var data = $("#new_phone").serialize();
  updateUserContactInfo('/phone/', data, 'post')
});

$(document).on("click","#add-usage-user-email-address.ajax",function(){
  addUserContactInfo('/email_address/new/');
});

$(document).on('click', '#submit-usage-user-email-address-form.ajax', function(e){
  var data = $("#new_email_address").serialize();
  updateUserContactInfo('/email_address/', data, 'post')
});

$(document).on("click",".update-usage-user-phone.ajax",function(){
  var Id = $(this).attr("id");
  addUserContactInfo('/phone/'+Id+'/edit/');
});

$(document).on('click', '#update-usage-user-phone-detail.ajax', function(e){
  var userId = $('#usage-user-id').val();
  var Id = $(this).attr('data-id');
  var data = $("#edit_phone_"+Id).serialize() + ("&user_id="+userId);
  updateUserContactInfo('/phone/'+Id, data, 'put')
});

$(document).on('railsAutocomplete.select', '#profile-assign-to-user.ajax', function(event, data){
  var data = { 'user_id': data.item.id,
               'profile_id': $(this).data('profile-id'), 'top_tab_bar': $(this).data('top_tab_bar')
             }
  url = "/usage/profiles/assign_profile.js"
  fire_ajax(url, data, 'put');
});

$(document).on('railsAutocomplete.select', '#mass-assigning-profile.ajax', function(event, data){
  var profileIds = [];
  $(".select-checkbox:checked").each(function(){ profileIds.push($(this).attr("data-id"));});
  data = { profile_ids: profileIds.join(","), user_id: data.item.id };
  url = "/usage/users/assign_profile"
  fire_ajax(url, data, 'put');
});

$(document).on('click', '#assigning-profile-model.ajax', function(){
  ids = [];
  $(".select-checkbox:checked").each(function(){ ids.push($(this).attr("data-id"));});
  if (ids.length === 0) {
    alert('Please select at least one');
    return;
  }
  $.ajax({
    url: '/usage/users/' + 'assign_profile_model',
    type: 'get',
    success: function(data) {
      $('#assign-profile-modal-pop-up').modal('show');
      $('#assign-profile-modal-pop-up').html(data)
    }
  });
});

var openEditNewModalForUsageNote = function(url, data) {
  $.ajax({
    url: url,
    data: data,
    type: 'get',
    success: function(data) {
      $('#modal-container-for-add-edit-usage-note').modal({show:true});
      $('#modal-container-for-add-edit-usage-note').html(data)
    }
  });
}

var addUpdateUsageNote = function(url, data, type) {
  $.ajax({
    url: url,
    data: data,
    type: type,
    success: function(data) {
      $("#modal-container-for-add-edit-usage-note").modal('hide');
      loadPage('main-container', CLU_BASE_URLS.usageNotesBaseURL + '?user_id=' + $('#usage-note-user-id').val());
    },
    error: function(data) {
    }
  });
}

$(document).on("click","#new-note-usage-modal-pop-up.ajax",function(){
  var userId = $('#usage-note-user-id').val();
  var data = { user_id: userId };
  openEditNewModalForUsageNote(CLU_BASE_URLS.usageNotesBaseURL+'new', data)
});

$(document).on('click',"#new-note-usage-modal-form-submit.ajax", function(e){
  var data = $("#new_usage_note").serialize()+('&user_id='+$('#usage-note-user-id').val());
  addUpdateUsageNote(CLU_BASE_URLS.usageNotesBaseURL, data, 'post');
});

$(document).on("click","#edit-note-usage-modal-pop-up.ajax",function(){
  var noteId = $(this).attr("data-note-id");
  var userId = $('#usage-note-user-id').val();
  var data = { user_id: userId};
  openEditNewModalForUsageNote(CLU_BASE_URLS.usageNotesBaseURL+ noteId +'/edit', data)
});

$(document).on('click', "#edit-note-usage-modal-form-submit.ajax", function(e){
  var id = $(this).attr('data-id');
  var data = $("#edit_usage_note_"+id).serialize()+('&user_id='+$('#usage-note-user-id').val());
  addUpdateUsageNote(CLU_BASE_URLS.usageNotesBaseURL+id, data, 'put');
});

$(document).on('click', "#delete-usage-note.ajax", function(){
  var containerID = "main-container";
  var url = CLU_BASE_URLS.usageNotesBaseURL+$(this).attr('data-note-id');
  var userId = $('#usage-note-user-id').val();
  var data = {user_id: userId, container_id: containerID };
  fire_ajax(url, data, 'delete');
});

$(document).on('click', ".user-system-task-checkbox.ajax", function(){
  var statusID = $(this).attr("data-status-id");
  var id = $(this).attr("data-id");
  var date = $(this).is(':checked') ? new Date() : "";
  var userId = $('#task-status-user-id').val();
  $.ajax({
    url: CLU_BASE_URLS.crmSystemTasksBaseURL + id,
    data: { 'crm_system_task' : {'completed_at' : date}, status_id: statusID },
    type: 'put',
    success: function(data) {
      if ($('#current-user-dashboard').length > 0  ) {
        fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + 'dashboard', {}, 'get');
      }
      else {
        loadPage('user-incomplete-tasks-container', CLU_BASE_URLS.usageUsersBaseURL + 'incomplete_tasks?user_id='+userId);
        loadPage('user-completed-tasks-container', CLU_BASE_URLS.usageUsersBaseURL + 'completed_tasks?user_id='+userId);
      }
    },
    error: function(data) {
    }
  });
});

$(document).on('click', '#button-search-user-incomplete-tasks.ajax', function(){
  var searchStr = $('#input-search-user-incomplete-tasks').val();
  var userId = $('#task-status-user-id').val();
  var url = CLU_BASE_URLS.usageUsersBaseURL + 'incomplete_tasks';
  var data = { q: searchStr, user_id: userId, container_id: 'user-incomplete-tasks-container'};
  fire_ajax(url, data, 'get');
});

$(document).on('click', '#button-search-user-completed-tasks.ajax', function(){
  var searchStr = $('#input-search-user-completed-tasks').val();
  var userId = $('#task-status-user-id').val();
  var url = CLU_BASE_URLS.usageUsersBaseURL + 'completed_tasks';
  var data = { q: searchStr, user_id: userId, container_id: 'user-completed-tasks-container'};
  fire_ajax(url, data, 'get');
});

$(document).on('click', '#user-follow-up-task-link.ajax', function(){
  var caseID = $(this).attr('data-case-id');
  var data = {case_id: caseID, connection_tab: 'cases_index', case_detail: 'follow_up'};
  fire_ajax(CLU_BASE_URLS.crmConnectionBaseURL+'connection_summary', data, 'get');
});

/*
$(document).on('click', '#create-new-user.ajax', function(){
  $.ajax({
    url: CLU_BASE_URLS.usageUsersBaseURL,
    data: $('#new_contact_info').serialize(),
    type: 'post',
    error: function(data) {
      alert("something went wrong...");
    }
  });
});
*/
