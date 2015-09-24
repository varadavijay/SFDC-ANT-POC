/**
 *
 */


var ppcOrderForm = (function() {

	var jj$ = jQuery.noConflict();

	function init() {

		jj$(document).ready(function(){
			var t=setTimeout(function(){
			jj$("input[name='firstname']").blur();
			jj$(".ppc-input-normal").first().focus();
			jj$("html, body").animate({ scrollTop: 0 }, "fast");
			},300)

			setCategoryOnchange();

			getIndustryCategory(jj$("#initialKtIndustryCategoryId").val(), jj$("#initialKtFocusCategoryId").val());

			if (document.getElementById("managementFee").value == 'undefined' || document.getElementById("managementFee").value == '') {
				document.getElementById("managementFee").value = 30;
			}
			updateSpendSchedule("managementFee", jj$("#quantity").val(), jj$("#totalRetail").val());

			if (jj$('#ppcFormStatus').val() == "true") {
				jj$('#ppcBlockDiv').find('input, textarea, button, select').attr('disabled','disabled');
				jj$('#formStatus').text("This order has been submitted to the Paid Media team");

			}
		});
	}

	function updateSpendSchedule(id, quantity, totalAmount) {

		var managementFee = parseFloat(document.getElementById(id).value);

		var periods = parseFloat(quantity);

		var monthlySpend = parseFloat(totalAmount) / parseFloat(periods);

		var ppcMonthlySpend = parseFloat(monthlySpend - (monthlySpend * (managementFee *.01)));
		jj$('#ppcMonthlySpendCell').text('$' + ppcMonthlySpend.formatMoney(0, '.', ','));

	}

	function setCategoryOnchange() {
		jj$('#ktIndustryCategoryId').change(function()
		{
			getFocusCategory(jj$(this).val());
			jj$("#ktIndustryCategoryId__c").val(jj$(this).val());

		});
		jj$('#ktFocusCategoryId').change(function()
		{
			jj$("#ktFocusCategoryId__c").val(jj$(this).val());
		});
	}
	
	function getIndustryCategory(industryCategoryId, focusCategoryId) {

		 sforce.connection.remoteFunction({
		   url : "https://amp.glplatform.com/api/KeywordSearch/VerticalIndustrySearch?verticalName=",
		   requestHeaders: {"Content-Type":"application/json"},
		   onSuccess : function(response) {

				var obj = jj$.parseJSON(response);
				var options = jj$("#ktIndustryCategoryId");

				if ((typeof industryCategoryId == 'undefined') || (industryCategoryId == 0)) {
					options.append(jj$("<option selected/>").val(0).text("-- None --"));
				} else {
					options.append(jj$("<option/>").val(0).text("-- None --"));
				}
				var obj2 = sortJSON(obj,'CategoryName');

				jj$.each( obj2, function( i, itemData ) {
					if ((typeof industryCategoryId != 'undefined') && (industryCategoryId == itemData.CategoryId)) {
						options.append(jj$("<option selected />").val(itemData.CategoryId).text(itemData.CategoryName));
					} else {
						options.append(jj$("<option />").val(itemData.CategoryId).text(itemData.CategoryName));
					}
				});

				if ((typeof focusCategoryId != 'undefined') && (industryCategoryId == "-1")) {
					options.append(jj$("<option selected/>").val("-1").text("Other"));
					jj$("#reasonForOtherDiv").show();
				} else {
					options.append(jj$("<option/>").val("-1").text("Other"));
				}


				if ((typeof industryCategoryId != 'undefined') && (typeof focusCategoryId != 'undefined')) {
					getFocusCategory(industryCategoryId, focusCategoryId);
				} else {
					getFocusCategory();
				}
			},
			onFailure : function(error) {
				//alert("fails");
			}
		 });
	}
	

	function sortJSONAfterFirst(data, key) {
		if (data.length >0) {
			var firstItem = data[0];
			data.shift();
			var newData = sortJSON(data, key)
			newData.unshift(firstItem);
			return newData;
		}
	}
	function sortJSON(data, key) {
		return data.sort(function(a, b) {
			var x = a[key]; var y = b[key];
			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		});
	}

	
    function AddChildren(obj, options, depth) {
        depth++;
        
        var obj2 = sortJSON(obj,'CategoryName');
        jj$.each(obj2, function (i, itemData) {
            if ((typeof industryCategoryId != 'undefined') && (industryCategoryId == itemData.CategoryId)) {
                options.append(jj$("<option selected />").val(itemData.CategoryId).text(itemData.CategoryName));
            } else {
                options.append(jj$("<option />").val(itemData.CategoryId).html("&nbsp;".repeat(depth * 2) + itemData.CategoryName));
            }

            if (itemData.Children.length > 0) {
                AddChildren(itemData.Children, options, depth);
            }
        });
    }	
    
    String.prototype.repeat = function (num) {
        return new Array(num + 1).join(this);
    }    

	function getFocusCategory(industryCategoryId, focusCategoryId) {

		jj$('#ktFocusCategoryId').children().remove();

		var options = jj$("#ktFocusCategoryId");

		if ((typeof industryCategoryId == 'undefined') || (industryCategoryId == 0)) {
			// no category selected
			options.append(jj$("<option selected/>").val(0).text("-- None --"));
			document.getElementById(jj$("#ktFocusCategoryIdField").val()).value = "0";
			document.getElementById(jj$("#ktFocusCategoryNameField").val()).value = "-- None --";
		} else {

			 sforce.connection.remoteFunction({
			   url : "https://amp.glplatform.com/api/KeywordSearch/VerticalFocusSearch?industryId=" + industryCategoryId + "&verticalName=" ,
			   requestHeaders: {"Content-Type":"application/json"},
			   onSuccess : function(response) {
					var obj = jj$.parseJSON(response);

					var obj2 = sortJSONAfterFirst(obj,'CategoryName');
					
			        var depth = 1;
			        
					jj$.each( obj2, function( i, itemData ) {
						if ((typeof focusCategoryId != 'undefined') && (focusCategoryId == itemData.CategoryId)) {
							options.append(jj$("<option selected />").val(itemData.CategoryId).text(itemData.CategoryName));
						} else {
							options.append(jj$("<option />").val(itemData.CategoryId).text(itemData.CategoryName));
						}
			            depth = 1;
			            if (itemData.Children.length > 0) {

			                AddChildren(itemData.Children, options, depth);

			            }						
					});

					if ((typeof focusCategoryId != 'undefined') && (focusCategoryId == "-1")) {
						options.append(jj$("<option selected/>").val("-1").text("Other"));
						jj$("#reasonForOtherDiv").show();
					} else {
						options.append(jj$("<option/>").val("-1").text("Other"));
					}
					if ((typeof focusCategoryId == 'undefined') || (focusCategoryId == "-1") || (focusCategoryId == "0")) {
						document.getElementById(jj$("#ktFocusCategoryIdField").val()).value = jj$('#ktFocusCategoryId option:first-child').val();
						document.getElementById(jj$("#ktFocusCategoryNameField").val()).value = jj$('#ktFocusCategoryId option:first-child').text();  
					}
				  }
			 });
		 }
	}

	function updateFocusCategoryId(id,name) {
		document.getElementById(id).value = jj$("#ktFocusCategoryId option:selected").val();
		document.getElementById(name).value = jj$("#ktFocusCategoryId option:selected").text().replace(/^\s+|\s+$/g,'');
		if (document.getElementById(id).value == "-1") {
			jj$("#reasonForOtherDiv").show();
		} else {
			jj$("#reasonForOtherDiv").hide();
			jj$("#reasonForOtherDiv").find("textarea").val("");
		}
	}
	function updateIndustryCategoryId(id,name,fid,fname) {
		document.getElementById(id).value = jj$("#ktIndustryCategoryId option:selected").val();
		if (document.getElementById(id).value == '0') {
			document.getElementById(fid).value = '0';
		}
		document.getElementById(name).value = jj$("#ktIndustryCategoryId option:selected").text();
		if (document.getElementById(id).value == "-1") {
			jj$("#reasonForOtherDiv").show();
		} else {
			jj$("#reasonForOtherDiv").hide();
			jj$("#reasonForOtherDiv").find("textarea").val("");
		}
	}
	function validateSearchEngine(id)
	{
		var rawId = id;
		id = '#' + id.replace(/:/g,"\\:");
		if(!(jj$(id).is(':checked'))) {
			jj$(id).parent().find('input:checkbox').each(function () {
				  if (rawId != this.id) {
				  	jj$(this).attr('checked', 'checked');
				  	jj$(this).prop('checked', true);
				  }
			});
		}
	}
	function validateReasonForOther(reasonForOtherId, industryId, focusId) {

		if (jj$("#" + industryId.replace(/:/g,"\\:")).val() === '0') {
			alert("You must select an Advertiser Industry and Campaign Focus!")
			return false;
		} else {
			if (jj$("#" + industryId.replace(/:/g,"\\:")).val() === '-1' || jj$("#" + focusId.replace(/:/g,"\\:")).val() === '-1') {
				if (jj$("#" + reasonForOtherId.replace(/:/g,"\\:")).val().length < 5) {
					alert("You must enter a Advertiser Industry or Campaign Focus (5 characters min)!")
					return false
				} else {
					return true;
				}
			}
		}
	}

	return {
		init: function() {
			init();
		},
		updateSpendSchedule: function(id, quantity, totalAmount) {
			return updateSpendSchedule(id, quantity, totalAmount);
	    },
	    updateFocusCategoryId: function(id,name) {
			return updateFocusCategoryId(id,name);
	    },
	    updateIndustryCategoryId: function(id,name,fid,fname) {
			return updateIndustryCategoryId(id,name,fid,fname);
	    },
	    validateSearchEngine: function(id) {
			return validateSearchEngine(id);
	    },
	    validateReasonForOther: function(reasonForOtherId, industryId, focusId) {
	    	return validateReasonForOther(reasonForOtherId, industryId, focusId);
	    }
	}
})();

ppcOrderForm.init();

function CallPostbackFunction(id)
{
	var elementValue = document.getElementById(id).value;
	callMethod(elementValue);
}

Number.prototype.formatMoney = function(c, d, t){
	var n = this,
	    c = isNaN(c = Math.abs(c)) ? 2 : c,
	    d = d == undefined ? "." : d,
	    t = t == undefined ? "," : t,
	    s = n < 0 ? "-" : "",
	    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
	    j = (j = i.length) > 3 ? j % 3 : 0;
	   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};
