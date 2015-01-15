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
//= require jquery.validate
//= require jquery.validate.min
//= require jquery_ujs
//= require_tree .
function popupCenter(url, width, height, name) {
	var left = (screen.width / 2) - (width / 2);
	var top = (screen.height / 2) - (height / 2);
	return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top);
}

$(document).ready(function() {
	$("a.popup").click(function(e) {
		popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
		e.stopPropagation();
		return false;
	});
	if (window.opener) {
		window.opener.location.replace('http://localhost:3000/acc');
		window.close()
	}
	jQuery.validator.addMethod("alphaNumeric", function(value, element) {
		return this.optional(element) || /^(?=\D*\d)(?=[^a-z]*[a-z])[0-9a-z]+$/i.test(value);
	}, "must contain atleast one number and one character");
	jQuery.validator.addMethod("require_at_least", function(value, element, options) {
		var least = options[0];
		var group = options[1];
		var fields = $(group, element.form);
		console.log(fields)
		var filled_fields = fields.filter(function() {
			return $(this).val() != "";
		});
		var empty_fields = fields.not(filled_fields);
		if (filled_fields.length < least && empty_fields[0] == element || empty_fields[1] == element) {
			return false;
		}
		return true;
	}, "please enter username or password!");

	jQuery.validator.addMethod("validate", function(value, element) {
		var email = $("#email").val();
		var phonenumber = $("#phonenumber").val();
		var result = true;
		$.ajax({
			url : "welcome/checkavailable",
			type : "post",
			async : false,
			data : {
				email : email,
				phonenumber : phonenumber
			},
			success : function(status) {
				if (status === false) {
					result = false;
				} else {
					result = true;
				}
			}
		});
		return result;
	});
	$("#check").validate({
		groups : {
			at_least : "username password",
			check : "email phonenumber"
		},
		success : function(label, element) {
			label.text('OK!')
			label.addClass("validclass").css({
				"color" : "blue"
			})
			$(element).css({
				"border-color" : "",
				"background-color" : ""
			});
		},
		submitHandler : function(form) {
			form.submit();
			$("#valid").html("Congratulations! your account has been create").css("font-size", "0.8em");
			$("#valid").css("color", "#61ef80");
			$("#hideMsg").css("display", "block");
			var sec = $("#hideMsg span").text();
			timer = setInterval(function() {
				$('#hideMsg span').text(--sec);
				if (sec == 0) {
					$('#hideMsg').fadeOut('fast');
					clearInterval(timer);
				}
			}, 1000);
		},
		rules : {
			"username" : {
				remote : {
					url : "welcome/check",
					type : "post",
					data : {
						username : function() {
							return $("#username").val();
						}
					}
				},
				require_at_least : [1, ".inputbox"]
			},
			"password" : {
				require_at_least : [1, ".inputbox"],
				minlength : 3,
				alphaNumeric : true,
			},
			"email" : {
				required : {
					depends : function(element) {
						return ($('#phonenumber').val() == '');
					}
				},
				email : true,
				validate : true
			},
			"phonenumber" : {
				required : {
					depends : function(element) {
						return ($('#email').val() == '');
					}
				},
				minlength : 3,
				number : true,
				validate : true
			},
		},
		messages : {
			"username" : {
				remote : "Name already taken!"
			},
			"password" : {
				minlength : "min lenght is 3 char"
			},
			"email" : {
				required : "email or phone number not null!",
				email : "A valid email address is required",
				validate : "Email already taken!"
			},
			"phonenumber" : {
				required : "email or phone number not null!",
				minlength : "Min Length is 3 characters",
				number : "phone must be number!",
				validate : "Phone already taken!"
			}
		},
		errorPlacement : function(label, element) {
			element.css({
				"border-color" : "#f7f7f7",
				"background-color" : "#fbe1e1",
				"opacity" : "0.6"
			});
			element.after(label);
			label.addClass("validclass");
			label.css({
				"color" : "red"
			})
		},
	});
});
