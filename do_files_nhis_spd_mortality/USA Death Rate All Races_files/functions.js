// JavaScript Document

function CheckMultiple1(frm, name) {
	for (var i=0; i < frm.length; i++)
	{
		fldObj = frm.elements[i];
		fldId = fldObj.id;
		if (fldId) {
			var fieldnamecheck=fldObj.id.indexOf(name);
			if (fieldnamecheck != -1) {
				if (fldObj.checked) {
					return true;
				}
			}

		}

	}
	return false;
}
function CheckForm1(f) {
		var email_re = /[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i;
		if (!email_re.test(f.email.value)) {
			alert("Please enter your email address.");
		f.email.focus();
		return false;
	}
	return true;
}

function createIeObject(url, base){
   var div = document.createElement("div");
   div.innerHTML = "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'><param name='movie' value='" +url + "'><param name='bgcolor' value='#000000'><param name='wmode' value='transparent'><param name='base' value='" +base + "'></object>";
   return div.firstChild;
}
function createFlashMarkup(width,height,uri,replaceid, base){
    var target_element = document.getElementById(replaceid),
    isMSIE = /*@cc_on!@*/false,
    obj = (isMSIE) ? createIeObject(uri, base) : document.createElement("object");
    if (!isMSIE) {
       obj.setAttribute("type", "application/x-shockwave-flash");
       obj.setAttribute("data", uri);
    }
    //Add attributes to <object>
    obj.setAttribute("id",replaceid+'-flash');
    obj.setAttribute("width", width);
    obj.setAttribute("height", height);
    obj.setAttribute("bgcolor", "#000000");
    obj.setAttribute("wmode", "transparent");
    obj.setAttribute("base", base);
    
    //Add <param> node(s) to <object>
    var param_1 = document.createElement("param");
    param_1.setAttribute("name", "base");
    param_1.setAttribute("value", base);
    obj.appendChild(param_1);    
 
    target_element.appendChild(obj);
}
