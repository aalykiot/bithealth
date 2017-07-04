var flag = false;
	        
// If newNotifications > 0 add transition to css
	        
$(document).ready(function() {

	$("#newNotElement").css({
		WebkitTransition : 'color 1.5s ease-in-out',
		MozTransition    : 'color 1.5s ease-in-out',
		MsTransition     : 'color 1.5s ease-in-out',
		OTransition      : 'color 1.5s ease-in-out',
		transition       : 'color 1.5s ease-in-out'
	});
	        	
});


	        
setInterval(function() {

	flag = !flag;
	
	$("#newNotElement").css("color", flag ? "#E58600" : "#9d9d9d");	

}, 1500);