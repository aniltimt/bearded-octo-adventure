// set defaults for X-editable Bootstrap
$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.showbuttons = false;
$.fn.editable.defaults.emptytext = 'empty';
$.fn.editable.defaults.onblur = 'submit';
$.fn.editable.defaults.toggle = 'click';

// chain $.fn.editable
// this chain produces the behaviour that focus fires a click
$.fn._chainedEditable = $.fn.editable;
$.fn.editable = function(option){
	this.on('focus',function(){
		this.click();
	});
	this._chainedEditable(option);
};
// chain $.fn.editable.defaults
$.fn.editable.defaults = $.fn._chainedEditable.defaults;