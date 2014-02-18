var loadPage = function(containerId, url){
  $.ajax({
    url : url,
    type: "get",
    contentType: "script",
    data: {container_id: containerId}
  });
}

var addConnectionContactInfo = function(url){
  var connectionId = $('#crm-connection-id').val();
  $.ajax({
    url: url,
    data: { connection_id: connectionId },
    type: 'get',
    success: function(data) {
      $('#container-contact-info-modal-pop-up').modal({show:true});
      $('#container-contact-info-modal-pop-up .modal-body').html(data)
    }
  });
}

var updateConnectionContactInfo = function(url, data, type){
  var connectionId = $('#crm-connection-id').val();
  $.ajax({
    url: url,
    data: data,
    type: type,
    success: function(data) {
      $("#container-contact-info-modal-pop-up").modal('hide');
      if ($('#crm-connection-edit-js-page').length > 0  ) {
        fire_ajax('/crm/connections/' + connectionId + '/edit.js', {}, 'get');
      }
      else {
        loadPage("crm-connection-summary", CLU_BASE_URLS.crmConnectionBaseURL + 'personal?connection_id=' + connectionId);
      }
    }
  });
}

var openEditNewModalForCrmNote = function(url, data) {
  $.ajax({
    url: url,
    data: data,
    type: 'get',
    success: function(data) {
      $('#modal-container-for-add-edit-note').modal({show:true});
      $('#modal-container-for-add-edit-note').html(data)
    }
  });
}

var addUpdateCrmNote = function(url, data, type) {
  $.ajax({
    url: url,
    data: data,
    type: type,
    success: function(data) {
      $("#modal-container-for-add-edit-note").modal('hide');
      if ($('#crm-connection-edit-js-page').length > 0  ) {
        loadPage("connection-notes.ajax", CLU_BASE_URLS.crmNotesBaseURL + '?connection_id=' + $('#crm_note_connection_id').val());
      }
      else {
        var caseId = $('#crm-note-case-id').val();
        var connectionId = $('#crm-note-connection-id').val();
        params_str = (caseId==="") ? '?connection_id='+connectionId : '?case_id='+caseId
        var containerID = $('#container-to-load-notes').val();
        fire_ajax(CLU_BASE_URLS.crmNotesBaseURL + params_str, {container: containerID}, 'get');
      }
    },
    error: function(data) {
    }
  });
}

$(document).on('click', '#select-all-checkbox', function () {
  if ($(this).is(':checked')){
    $('.select-checkbox:not(:checked)').click();
  }else{
    $('.select-checkbox:checked').click();
  }
});

/*
$(document).on("click", "ul#client-connection-tabs li a.ajax", function(){
  var action_url = $(this).attr("href");
  loadPage('crm-connection-summary', action_url);
});
*/

$(document).on("click",".crm-case-tagging-pop-up.ajax",function(){
  var connectionId = $(this).attr('connection_id');
  var data = { connection_id: connectionId, connection_tab: 'connection_tags' };
  fire_ajax(CLU_BASE_URLS.crmConnectionBaseURL+'connection_summary', data, 'get');
});

$(document).on('click', '#delete-crm-cases.ajax', function () {
  var baseURL = $(this).attr('data-base-url');
  var action = $(this).attr('data-action');
  caseIds = [];
  $(".select-checkbox:checked").each(function(){ caseIds.push($(this).attr("data-id"));});
  $.ajax({
    url: CLU_BASE_URLS.crmCaseBaseURL + caseIds[0],
    data: { case_ids: caseIds.join(",") },
    type: 'delete',
    success: function() {
      $.ajax({
        url: baseURL + action + '?mgr='+$("#user-is-manager").val()+'&tab_selected='+$("#get-tab-value-to-display").val()
      });
    }
  });
});

$(document).on('click', 'ul#crm-case-detail-tabs a.ajax', function(){
  var uRL = $(this).attr("data-href");
  $('ul#crm-case-detail-tabs li').removeClass('active');
  $(this).closest('li').addClass('active');
  if ( $("ul#crm-cases-tabs li.active a").length > 0 ) {
    var caseId = $("ul#crm-cases-tabs li.active a").attr("href").replace('#','');
    $('#case-pane-tab-content').html('');
    loadPage("case-pane-tab-content", uRL + '?case_id=' + caseId);
  }
});

$(document).on('click', "ul#crm-cases-tabs a.ajax", function(){
  var statusID = $(this).attr("data-crm-case-status-id");
  if (statusID === "") {statusID = "no_status_id";}
  $('#crm-case-follow-up').attr('href', '#' + statusID);
  setTimeout(function(){$("ul#crm-case-detail-tabs li.active a").trigger("click");}, 200);
});

$(document).on("click","#new-note-modal-pop-up.ajax",function(){
  var caseId = $('#crm-note-case-id').val();
  var connectionId = $('#crm-note-connection-id').val();
  var isEditConnectionPage = ($('#crm-connection-edit-js-page').length > 0);
  var data = {case_id: caseId, connection_id: connectionId, edit_page: isEditConnectionPage};
  openEditNewModalForCrmNote(CLU_BASE_URLS.crmNotesBaseURL+'new', data)
});

$(document).on('click', "#new-note-modal-form-submit.ajax", function(e){
  var data = $("#new_crm_note").serialize();
  addUpdateCrmNote(CLU_BASE_URLS.crmNotesBaseURL, data, 'post');
});

$(document).on('click', '#button-search-client', function(e){
  var search = $('#input-search-client').val();
  var baseURL = $(this).attr("data-base-url");
  var action = $(this).attr("data-action");
  $.ajax({
    url: baseURL + action,
    data: { q: search, mgr: $("#user-is-manager").val(), tab_selected: $("#get-tab-value-to-display").val()},
    type: 'get',
    error: function(data) {
      alert("something went wrong...");
    }
  });
});

$(document).on('click', '#delete-crm-connections.ajax', function () {
  connectionIds = [];
  var action = $("#connection-action").val()=="index" ? '' : $("#connection-action").val();
  var urlToLoad = CLU_BASE_URLS.crmConnectionBaseURL + action + "?mgr="+$("#user-is-manager").val()+'&tab_selected='+$("#get-tab-value-to-display").val();
  $(".select-checkbox:checked").each(function(){ connectionIds.push($(this).attr("data-id"));});
  if (connectionIds.length === 0) { return; }
  $.ajax({
    url: CLU_BASE_URLS.crmConnectionBaseURL + connectionIds[0],
    data: { connection_ids: connectionIds.join(",") },
    type: 'delete',
    success: function() {
      $.ajax({
        url: urlToLoad
      });
    },
    error: function() {
      alert("something went wrong...");
    }
  });
});

$(document).on('click', '.delete-connection-tag.ajax', function () {
  var tagId = $(this).attr("data-tag-id");
  var connectionId = $(this).attr("data-connection-id");
  $.ajax({
    url: CLU_BASE_URLS.crmConnectionBaseURL + 'destroy_connection_tag',
    data: { connection_id: connectionId, tag_id: tagId },
    type: 'get',
    success: function() {
    },
    error: function() {
      alert("something went wrong...");
    }
  });
});

$(document).on('change', '#crm_case_exam_company', function(){
  var scheduleURL = $(this).val();
  $('#exam-company-order-button').attr('href', scheduleURL);
});

$(document).on("dblclick","#crm-connection-edit-form.ajax",function(){
  var connectionId = $(this).attr("data-connection-id");
  $.ajax({
    url: '/crm/connections/' + connectionId + '/edit.js',
    type: 'get'
  });
});

$(document).on("change","#crm_status_status_type_id.ajax",function(){
  var statusTypeId = $(this).val();
  var caseId = $('#crm-case-id').val();
  $.ajax({
    url: CLU_BASE_URLS.crmStatusesBaseURL,
    data: { case_id: caseId, status_type_id: statusTypeId },
    type: 'post',
    success: function(data) {
      $('#crm-case-follow-up').attr('href', '#' + data.status_id);
      loadPage("case-pane-tab-content", '/crm/statuses/' + data.status_id);
    },
    error: function() {
      alert("something went wrong...");
    }
  });
});

$(document).on("click","#add-crm-connection-phone.ajax",function(){
  addConnectionContactInfo('/phone/new/');
});

$(document).on('click', '#submit-phone-form', function(e){
  var data = $("#new_phone").serialize();
  updateConnectionContactInfo('/phone/', data, 'post');
});

$(document).on("click","#add-crm-connection-email-address.ajax",function(){
  addConnectionContactInfo('/email_address/new/');
});

$(document).on('click', '#submit-email-address-form', function(e){
  var data = $("#new_email_address").serialize();
  updateConnectionContactInfo('/email_address/', data, 'post');
});

$(document).on("click",".update-crm-connection-phone.ajax",function(){
  var Id = $(this).attr("id");
  addConnectionContactInfo('/phone/'+Id+'/edit/');
});

$(document).on('click', '#update-phone-detail', function(e){
  var Id = $(this).attr('data-id');
  var connectionId = $('#crm-connection-id').val();
  var data = $("#edit_phone_"+Id).serialize() + ("&connection_id="+connectionId);
  updateConnectionContactInfo('/phone/'+Id, data, 'put');
});

$(document).on('click', '#assigning-agent.ajax', function(){
  ids = [];
  $(".select-checkbox:checked").each(function(){ ids.push($(this).attr("data-id"));});
  if (ids.length === 0) {
    alert('Please select at least one');
    return;
  }
  $.ajax({
    url: '/usage/users/' + 'assign_agent',
    type: 'get',
    success: function(data) {
      $('#assign-agent-modal-pop-up').modal({show:true});
      $('#assign-agent-modal-pop-up').html(data)
    }
  });
});

$(document).on('click', '#financial_questionnaire.ajax', function(){
  ids = [];
  $(".select-checkbox:checked").each(function(){ ids.push($(this).attr("data-id"));});
  if (ids.length === 0) {
    alert('In Progress');
    return;
  }
  $.ajax({
    url: '/usage/users/' + 'assign_agent',
    type: 'get',
    success: function(data) {
      $('#assign-agent-modal-pop-up').modal({show:true});
      $('#assign-agent-modal-pop-up').html(data)
    }
  });
});

$(document).on('railsAutocomplete.select', '#mass-assigning-agent.ajax', function(event, data){
  if (data.item.id==="") { return; }
  ids = [];
  var baseURL = $('#assigning-agent').attr('data-base-url');
  var action = $('#assigning-agent').attr('data-action');
  $(".select-checkbox:checked").each(function(){ ids.push($(this).attr("data-id"));});
  $.ajax({
    url: baseURL + 'update_agent',
    data: { ids: ids.join(","), agent_id: data.item.id },
    type: 'post',
    success: function() {
      $("#assign-agent-modal-pop-up").modal('hide');
      $.ajax({
        url: baseURL + action + '?mgr='+$("#user-is-manager").val()+'&tab_selected='+$("#get-tab-value-to-display").val()
      });
    },
    error: function() {
      alert("something went wrong...");
    }
  });
});

$(document).on("click","#add-spouse-to-connection.ajax",function(){
  var connectionId = $('#crm-connection-id').val();
  $.ajax({
    url: CLU_BASE_URLS.crmConnectionBaseURL + 'add_spouse',
    data: { connection_id: connectionId },
    type: 'get',
    success: function(data) {
      $('#container-spouse-modal-pop-up').modal({show:true});
      $('#container-spouse-modal-pop-up').html(data);
    }
  });
});

$(document).on('railsAutocomplete.select', '#add-spouse-to-crm-connection.ajax', function(event, data){
  if (data.item.id==="") { return; }
  var connectionId = $('#crm-connection-id').val();
  $.ajax({
    url: CLU_BASE_URLS.crmConnectionBaseURL + connectionId,
    data: { connection_id: connectionId, name: 'spouse_id', value: data.item.id},
    type: 'put',
    success: function(data) {
      $("#container-spouse-modal-pop-up").modal('hide');
      loadPage('crm-connection-summary', CLU_BASE_URLS.crmConnectionBaseURL + 'personal?connection_id='+connectionId);
    }
  });
});

$(document).on('click', '#expand-crm-notes', function(){
  $('.accordion-toggle').click();
});

$(document).on('click', "#close-contact-info-modal", function(){
  $('#container-contact-info-modal-pop-up').modal('hide');
});

$(document).on('click', "#button-close-crm-note-modal", function(){
  $('#modal-container-for-add-edit-note').modal('hide');
});

$(document).on("click","#add-crm-connection-website.ajax",function(){
  addConnectionContactInfo('/website/new/');
});

$(document).on('click', '#submit-website-form', function(e){
  var data = $("#new_website").serialize();
  updateConnectionContactInfo('/website/', data, 'post');
});

$(document).on("click",".edit-note-modal-pop-up.ajax",function(){
  var noteId = $(this).attr("data-note-id");
  var caseId = $('#crm-note-case-id').val();
  var connectionId = $('#crm-note-connection-id').val();
  var data = {case_id: caseId, connection_id: connectionId};
  openEditNewModalForCrmNote(CLU_BASE_URLS.crmNotesBaseURL+ noteId +'/edit', data)
});

$(document).on('click', '#edit-note-modal-form-submit', function(e){
  var id = $(this).attr('data-id');
  var data = $("#edit_crm_note_"+id).serialize();
  addUpdateCrmNote(CLU_BASE_URLS.crmNotesBaseURL+id, data, 'put');
});

$(document).on('click', ".delete-crm-note.ajax", function(){
  var url = CLU_BASE_URLS.crmNotesBaseURL+$(this).attr('data-note-id');
  var caseId = $('#crm-note-case-id').val();
  var connectionId = $('#crm-note-connection-id').val();
  var containerID = $('#container-to-load-notes').val();
  var data = {case_id: caseId, connection_id: connectionId, container: containerID};
  fire_ajax(url, data, 'delete');
});

$(document).on('click', '.crm-system-task-completed-checkbox.ajax', function(){
  var statusID = $('#crm-status-id').val();
  var id = $(this).attr("id");
  if ($(this).is(':checked')) {
    $('.crm-system-task'+id).prop('disabled', true);
    var date = new Date();
  }
  else {
    $('.crm-system-task'+id).prop('disabled', false);
    var date = "";
  }
  var data = { 'crm_system_task' : {'completed_at' : date}, status_id: statusID };
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + id, data, 'put');
  $('#crm-system-task-completed-at'+id).html($.datepicker.formatDate('yy-mm-dd', date));
});

$(document).on('change', '.crm-system-task-task-type-id.ajax', function(){
  var statusID = $('#crm-status-id').val();
  var id = ($('#new-edit-crm-system-task').length > 0) ? "" : $(this).parent().parent().attr("data-id");
  if ($(this).val() === "") {
    $('#crm_system_task'+id+'_assigned_to_id').prop('disabled', false);
    $('#crm_system_task'+id+'_template_name').prop('disabled', true);
  }
  else {
    $('#crm_system_task'+id+'_assigned_to_id').prop('disabled', true);
    $('#crm_system_task'+id+'_template_name').prop('disabled', false);
    $('#crm_system_task'+id+'_template_name').attr('data-autocomplete', '/marketing/memberships/membership_templates?task_type='+$(this).val());
  }
  if ($('#new-edit-crm-system-task').length > 0) { return; }
  var data = { 'crm_system_task' : {'task_type_id' : $(this).val()}, status_id: statusID };
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + id, data, 'put');
});

$(document).on('change', '.crm-auto-system-task-rule-task-type-id', function(){
  $('#crm_auto_system_task_rule_template_name').attr('data-autocomplete', '/marketing/memberships/membership_templates?task_type='+$(this).val());
});

$(document).on('railsAutocomplete.select', '#crm_auto_system_task_rule_template_name', function(event, data){
  $('#crm_auto_system_task_rule_template_id').val(data.item.id);
});

$(document).on('railsAutocomplete.select', '#crm_system_task_template_name', function(event, data){
  $('#crm_system_task_template_id').val(data.item.id);
});

$(document).on('change', '.crm-system-task-assigned-to.ajax', function(){
  var statusID = $('#crm-status-id').val();
  if ($('#new-edit-crm-system-task').length > 0) { return; }
  var id = $(this).parent().parent().attr("data-id");
  var data = { 'crm_system_task' : {'assigned_to_id' : $(this).val()}, status_id: statusID };
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + id, data, 'put');
});

$(document).on('railsAutocomplete.select', '.crm-system-task-template-id.ajax', function(event, data){
  var statusID = $('#crm-status-id').val();
  if ($('#new-edit-crm-system-task').length > 0) { return; }
  if (data.item.id==="") { return; }
  var data = { 'crm_system_task' : {'template_id' : data.item.id}, status_id: statusID };
  var id = $(this).parent().parent().attr("data-id");
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + id, data, 'put');
});

$(document).on('click', '#add-new-follow-up-task.ajax', function(){
  var statusID = $('#crm-status-id').val();
  var data = {status_id: statusID};
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + 'new', data, 'get');
});

$(document).on('click', '#create-follow-up-task.ajax', function(){
  var statusID = $('#crm_system_task_status_id').val();
  var data = $('#new_crm_system_task').serialize()+('&status_id='+statusID);
  $.ajax({
    url: CLU_BASE_URLS.crmSystemTasksBaseURL,
    data: data,
    type: 'post',
    success: function(data) {
      loadPage("case-pane-tab-content", '/crm/statuses/' + statusID);
    }
  });
});

$(document).on('click', '.add-new-crm-beneficiary.ajax', function(){
  var caseId = $('#crm-beneficiary-case-id').val();
  var beneficiaryType = $(this).attr('data-beneficiary-type') ? $(this).attr('data-beneficiary-type') : ""
  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL+'new?case_id='+caseId+'&beneficiary_type='+beneficiaryType;
  loadPage($(this).attr('data-container'), url);
});

var checkBeneficiaryValidOrNot = function(){
  if ($('#crm_beneficiary_genre_id').val() == ""){
    alert('Select Type');
    return false;
  }
  if ($('#crm_beneficiary_name').val().length<1){
    alert('Please Enter Name');
    return false;
  }
  if ($('#crm_beneficiary_genre_id option:selected').text() === 'person'){
    if ($('#crm_beneficiary_birth_or_trust_date').val() == ""){
      alert('Please Select Birth Date');
      return false;
    }
    if ($('#crm_beneficiary_gender').val() == ""){
        alert('Select Gender');
        return false;
    }
    if ($('#crm_beneficiary_relationship').val().length<1 ){
      alert('Please Enter Relationship');
      return false;
    }
    if ($('#crm_beneficiary_ssn_field').val().length<1 ){
      alert('Please Enter SSN');
      return false;
    }
  }
  else if ($('#crm_beneficiary_genre_id option:selected').text() === 'trust'){
    if ($('#crm_beneficiary_birth_or_trust_date').val() == ""){
      alert('Please Select Birth Date');
      return false;
    }
    if ($('#crm_beneficiary_trustee').val().length<1 ){
      alert('Please Enter Trustee');
      return false;
    }
  }
  return true;
}

$(document).on('change', '#crm_beneficiary_genre_id', function(){
  if ($('#crm_beneficiary_genre_id option:selected').text() === 'person'){
    $('#crm_beneficiary_gender').removeAttr('disabled');
    $('#crm_beneficiary_birth_or_trust_date').prop('disabled', false);
    $('#crm_beneficiary_relationship').prop('disabled', false);
    $('#crm_beneficiary_ssn_field').prop('disabled', false);
    $('#crm_beneficiary_trustee').prop('disabled', true);
  }
  else if ($('#crm_beneficiary_genre_id option:selected').text() === 'trust'){
    $('#crm_beneficiary_gender').attr('disabled', 'disabled');
    $('#crm_beneficiary_birth_or_trust_date').prop('disabled', false);
    $('#crm_beneficiary_relationship').prop('disabled', true);
    $('#crm_beneficiary_ssn_field').prop('disabled', true);
    $('#crm_beneficiary_trustee').prop('disabled', false);
  }
  else {
    $('#crm_beneficiary_gender').removeAttr('disabled');
    $('#crm_beneficiary_birth_or_trust_date').prop('disabled', false);
    $('#crm_beneficiary_relationship').prop('disabled', false);
    $('#crm_beneficiary_ssn_field').prop('disabled', false);
    $('#crm_beneficiary_trustee').prop('disabled', false);
  }
});

$(document).on('click', '#create-crm-beneficiary.ajax', function(){

  if (!checkBeneficiaryValidOrNot()) {
    return;
  };
  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL;
  var containerID = $('#container-to-update').val() ? $('#container-to-update').val() : "";
  var caseId = $('#crm-beneficiary-case-id').val();
  var data = $('#new_crm_beneficiary').serialize() + ('&case_id='+caseId+'&container_id='+containerID)
  fire_ajax(url, data, 'post')
});

$(document).on('click', '.delete-crm-beneficiary.ajax', function(){
  var id = $(this).parent().parent().attr('data-id');
  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL + id;
  var containerID = $('#container-to-update').val() ? $('#container-to-update').val() : "";
  var caseId = $('#crm-beneficiary-case-id').val();
  var data = { case_id: caseId, container_id: containerID };
  fire_ajax(url, data, 'delete')
});

$(document).on('click', '.edit-crm-beneficiary.ajax', function(){
  var id = $(this).parent().parent().attr('data-id');
  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL + id + '/edit';
  var containerID = $('#container-to-update').val() ? $('#container-to-update').val() : "";
  var caseId = $('#crm-beneficiary-case-id').val();
  var data = { case_id: caseId, container_id: containerID };
  fire_ajax(url, data, 'get')
});

$(document).on('click', '#update-crm-beneficiary.ajax', function(){

  if (!checkBeneficiaryValidOrNot()) {
    return;
  };
  var id = $('#crm_beneficiary_id').val();
  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL+id;
  var containerID = $('#container-to-update').val() ? $('#container-to-update').val() : "";
  var caseId = $('#update-crm-beneficiary-case-id').val();
  var data = $('#edit_crm_beneficiary_'+id).serialize() + ('&case_id='+caseId+'&container_id='+containerID)
  fire_ajax(url, data, 'put')
});

$(document).on('click', '#update-crm-beneficiaries-percentage.ajax', function(){

  var totalPrimaryPercentage = 0;
  var primaryPercentages = [];
  $("#container-primary-beneficiaries .beneficiaries_percentage").each(function(){
    totalPrimaryPercentage = totalPrimaryPercentage + parseFloat($(this).val());
    primaryPercentages.push($(this).val());
  });

  if (isNaN(totalPrimaryPercentage) || totalPrimaryPercentage < 100 || totalPrimaryPercentage > 100) {
    alert("Your Primary Beneficiary percentages must add up to 100%");
    return;
  }

  var totalSecondaryPercentage = 0;
  var secondaryPercentages = [];
  $("#container-secondary-beneficiaries .beneficiaries_percentage").each(function(){
    totalSecondaryPercentage = totalSecondaryPercentage + parseFloat($(this).val());
    secondaryPercentages.push($(this).val());
  });

  if ($("#container-secondary-beneficiaries .beneficiaries_percentage")>0) {
    if (isNaN(totalSecondaryPercentage) || totalSecondaryPercentage < 100 || totalSecondaryPercentage > 100) {
      alert("Your Secondary Beneficiary percentages must add up to 100%");
      return;
    }
  }

  var url = CLU_BASE_URLS.crmBeneficiariesBaseURL+'update_percentages';
  var caseId = $('#crm-beneficiary-case-id').val();
  var data = { primary_percentages: primaryPercentages.join(","), case_id: caseId,
               secondary_percentages: secondaryPercentages.join(",") };
  fire_ajax(url, data, 'post');
});

$(document).on('click', '#show-system-task-template-letter-body.ajax', function(){
  var containerID = $('#container-to-update').val() ? $('#container-to-update').val() : "";
  var statusID = $('#crm-status-id').val();
  var id = $(this).parent().parent().attr("data-id");
  var data = { status_id: statusID, container_id: containerID };
  fire_ajax(CLU_BASE_URLS.crmSystemTasksBaseURL + id, data, 'get');
});

$(document).on('click', '#create-crm-connection.ajax', function(){
  var action = $(this).attr("data-action");
  var baseURL = $(this).attr("data-base-url");
  $.ajax({
    url: CLU_BASE_URLS.crmConnectionBaseURL,
    type: 'post',
    error: function(data) {
      alert("something went wrong...");
    }
  });
});

$(document).on('click','#save_value', function(){
  var stuff = [];
  $('.select-checkbox:checked').each(function(){
    stuff.push($(this).val());
  });
  $('#connection_id').val(stuff);
});

$(document).on("change","#follow_up_openness_id.ajax",function(){
  var opennessID = $(this).val();
  var caseId = $('#crm-case-id').val();
  var statusID = $('#crm-status-id').val();
  var data = {case_id: caseId, crm_status: {openness_id: opennessID}};
  fire_ajax(CLU_BASE_URLS.crmStatusesBaseURL+statusID, data, 'put');
});
