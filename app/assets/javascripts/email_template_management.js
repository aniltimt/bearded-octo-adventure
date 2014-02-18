$(document).on('railsAutocomplete.select', '#edit-marketing-email-template.ajax', function(event, data){
  var base_url = $(this).data('base_url');
  var action = $(this).data('action');
  var url = base_url + data.item.id + "/" + action + ".js"
  fire_ajax(url, {}, 'get');
});

$(document).on('railsAutocomplete.select', '#set-template-body-parameters', function(event, data){
  if( data.item.value.match(/days_from_now \d+/) )
  {
    tinyMCE.execInstanceCommand('marketing_email_template_body',"mceInsertContent",false, "{%" + data.item.value +"%}");
  }
  else
  {
    tinyMCE.execInstanceCommand('marketing_email_template_body',"mceInsertContent",false, "{{" + data.item.value +"}}");
  }
});

$(document).on('railsAutocomplete.select', '#edit-marketing-snail-mail-template.ajax', function(event, data){
  var base_url = $(this).data('base_url');
  var action = $(this).data('action');
  var url = base_url + data.item.id + "/" + action + ".js"
  fire_ajax(url, {}, 'get');
});

$(document).on('railsAutocomplete.select', '#set-snail_mail-template-body-parameters', function(event, data){
  if( data.item.value.match(/days_from_now \d+/) )
  {
    tinyMCE.execInstanceCommand('marketing_snail_mail_template_body',"mceInsertContent",false, "{%" + data.item.value +"%}");
  }
  else
  {
    tinyMCE.execInstanceCommand('marketing_snail_mail_template_body',"mceInsertContent",false, "{{" + data.item.value +"}}");
  }
});

$(document).on('railsAutocomplete.select', '#set-message-body-parameters', function(event, data){
  if( data.item.value.match(/days_from_now \d+/) )
  {
    tinyMCE.execInstanceCommand('marketing_email_message_body',"mceInsertContent",false, "{%" + data.item.value +"%}");
  }
  else
  {
    tinyMCE.execInstanceCommand('marketing_email_message_body',"mceInsertContent",false, "{{" + data.item.value +"}}");
  }
});

$(document).on('railsAutocomplete.select', '#crm-connection-for-liquid', function(event, data){
  $("#marketing_email_message_connection_id").val(data.item.id);
});

$(document).on('railsAutocomplete.select', '#usage-user-for-liquid', function(event, data){
  $("#marketing_email_message_user_id").val(data.item.id);
});

$(document).on('change', '#marketing_email_message_template_id', function(){
  if( $(this).val() === "" )
  {
    $('#marketing_email_message_body_ifr').contents().find('body').attr('contenteditable', true);
    $("#set-message-body-parameters").attr('readonly',false);
  }
  else
  {
    $("#set-message-body-parameters").attr('readonly','readonly');
    tinyMCE.activeEditor.setContent("");
    $('#marketing_email_message_body_ifr').contents().find('body').attr('contenteditable', false);
  }
});

$(document).on('railsAutocomplete.select', '#crm-connection-for-snail_mail', function(event, data){
  $("#marketing_snail_mail_message_connection_id").val(data.item.id);
});

$(document).on('railsAutocomplete.select', '#usage-user-for-snail_mail', function(event, data){
  $("#marketing_snail_mail_message_user_id").val(data.item.id);
});

$(document).on('change', '#marketing_snail_mail_message_template_id', function(){
  if( $(this).val() === "" )
  {
    $('#marketing_snail_mail_message_body_ifr').contents().find('body').attr('contenteditable', true);
    $("#set-message-body-parameters").attr('readonly',false);
  }
  else
  {
    $("#set-message-body-parameters").attr('readonly','readonly');
    tinyMCE.activeEditor.setContent("");
    $('#marketing_snail_mail_message_body_ifr').contents().find('body').attr('contenteditable', false);
  }
});

$(document).on('railsAutocomplete.select', '#set-message-body-parameters', function(event, data){
  if(data.item.value.match(/days_from_now \d+/))
  {
    tinyMCE.execInstanceCommand('marketing_snail_mail_message_body',"mceInsertContent",false, "{%" + data.item.value +"%}");
  }
  else
  {
    tinyMCE.execInstanceCommand('marketing_snail_mail_message_body',"mceInsertContent",false, "{{" + data.item.value +"}}");
  }
});

$(document).on('click', "#send_email_message", function(){
  $("#marketing_email_message_send_email_message").val("Send");
});
