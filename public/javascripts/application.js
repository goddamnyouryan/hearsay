Ajax.Responders.register({
  onCreate: function() {
    if($('busy') && Ajax.activeRequestCount>0)
      Effect.Appear('busy',{duration:0.5,queue:'end'});
  },
  onComplete: function() {
    if($('busy') && Ajax.activeRequestCount==0)
      Effect.Fade('busy',{duration:0.5,queue:'end'});
  }
});

Ajax.Responders.register({
  onCreate: function() {
    if($('more') && Ajax.activeRequestCount>0)
      Effect.Appear('more',{duration:0.25,queue:'end'});
  },
  onComplete: function() {
    if($('more') && Ajax.activeRequestCount==0)
      Effect.Fade('more',{duration:0.25,queue:'end'});
  }
});

// endless_page.js
var currentPage = 1;

function checkScroll() {
    currentPage++;
    new Ajax.Request('/home?page=' + currentPage, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
}

var publicStream = 1;

function morePublic() {
    publicStream++;
    new Ajax.Request('/public_stream?public=' + publicStream, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
}

var friendsStream = 1;

function moreFriends() {
    friendsStream++;
    new Ajax.Request('/home/friends_stream?page=' + friendsStream, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
}

var catsPage = 1;

function moreCats() {
    catsPage++;
    new Ajax.Request('?page=' + catsPage, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
}
    
    
Event.observe(window, 'load', function() {
			slide.delay(2);
		});
		
		function slide(){
			Effect.SlideUp('flash',{duration:1.0});
		}
    

function silentErrorHandler() {return true;}
window.onerror=silentErrorHandler;


