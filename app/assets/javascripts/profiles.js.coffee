window.updateProfile = (select) ->
  $.post '/usage/profiles/select', {id: $(select).val()}