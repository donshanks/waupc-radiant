// Simulates PHP's date function
Date.prototype.format=function(format){var returnStr='';var replace=Date.replaceChars;for(var i=0;i<format.length;i++){var curChar=format.charAt(i);if(replace[curChar]){returnStr+=replace[curChar].call(this);}else{returnStr+=curChar;}}return returnStr;};Date.replaceChars={shortMonths:['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],longMonths:['January','February','March','April','May','June','July','August','September','October','November','December'],shortDays:['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],longDays:['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],d:function(){return(this.getDate()<10?'0':'')+this.getDate();},D:function(){return Date.replaceChars.shortDays[this.getDay()];},j:function(){return this.getDate();},l:function(){return Date.replaceChars.longDays[this.getDay()];},N:function(){return this.getDay()+1;},S:function(){return(this.getDate()%10==1&&this.getDate()!=11?'st':(this.getDate()%10==2&&this.getDate()!=12?'nd':(this.getDate()%10==3&&this.getDate()!=13?'rd':'th')));},w:function(){return this.getDay();},z:function(){return"Not Yet Supported";},W:function(){return"Not Yet Supported";},F:function(){return Date.replaceChars.longMonths[this.getMonth()];},m:function(){return(this.getMonth()<9?'0':'')+(this.getMonth()+1);},M:function(){return Date.replaceChars.shortMonths[this.getMonth()];},n:function(){return this.getMonth()+1;},t:function(){return"Not Yet Supported";},L:function(){return(((this.getFullYear()%4==0)&&(this.getFullYear()%100!=0))||(this.getFullYear()%400==0))?'1':'0';},o:function(){return"Not Supported";},Y:function(){return this.getFullYear();},y:function(){return(''+this.getFullYear()).substr(2);},a:function(){return this.getHours()<12?'am':'pm';},A:function(){return this.getHours()<12?'AM':'PM';},B:function(){return"Not Yet Supported";},g:function(){return this.getHours()%12||12;},G:function(){return this.getHours();},h:function(){return((this.getHours()%12||12)<10?'0':'')+(this.getHours()%12||12);},H:function(){return(this.getHours()<10?'0':'')+this.getHours();},i:function(){return(this.getMinutes()<10?'0':'')+this.getMinutes();},s:function(){return(this.getSeconds()<10?'0':'')+this.getSeconds();},e:function(){return"Not Yet Supported";},I:function(){return"Not Supported";},O:function(){return(-this.getTimezoneOffset()<0?'-':'+')+(Math.abs(this.getTimezoneOffset()/60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()/60))+'00';},P:function(){return(-this.getTimezoneOffset()<0?'-':'+')+(Math.abs(this.getTimezoneOffset()/60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()/60))+':'+(Math.abs(this.getTimezoneOffset()%60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()%60));},T:function(){var m=this.getMonth();this.setMonth(0);var result=this.toTimeString().replace(/^.+ \(?([^\)]+)\)?$/,'$1');this.setMonth(m);return result;},Z:function(){return-this.getTimezoneOffset()*60;},c:function(){return this.format("Y-m-d")+"T"+this.format("H:i:sP");},r:function(){return this.toString();},U:function(){return this.getTime()/1000;}};
this.readDate = function(str,fmt){ 
  str = (str.split('T'))[0];
  parts = str.split('-');
  var sd = (new Date(parts[0],parts[1]-1,parts[2])).format(fmt);
  return sd;
};

google.load('gdata','1');

/*
 * Retrieve events with a date query
 */ 

// The callback that will be called when getEventsFeed() returns feed data
var callback = function(root) {

  // Obtain the array of matched CalendarEventEntry
  var eventEntries = root.feed.getEntries();

  // If there is matches for the date query
  if (eventEntries.length > 0) {
    for (var i = 0; i < eventEntries.length; i++) {
      var event = eventEntries[i];
      // Print the event title of the matches
      var startDate = readDate( (event.getTimes())[0].startTime, 'F d, Y');
      $j('.events-sidebar ul').append(
        '<li><span class="date">' + startDate + '</span><br /> ' + event.getTitle().getText() + '</li>'
      );
    }
  } 
  else {
    // No match is found for the date query
    document.write('no events are matched from the query!');
  }

}

// Error handler to be invoked when getEventsFeed() produces an error
var handleError = function(error) {
  document.write(error);
}

// Submit the request using the calendar service object. Notice the CalendarEventQuery 
// object is passed in place of the feed URI
$j(function(){

  // Create the calendar service object
  var calendarService = new google.gdata.calendar.CalendarService('GoogleInc-jsguide-1.0');

  // The default "private/full" feed is used to retrieve events from 
  // the primary private calendar with full projection 
  var feedUri = 'http://www.google.com/calendar/feeds/waupci%40gmail.com/public/full';

  // Create a CalendarEventQuery, and specify that this query is 
  // applied toward the "private/full" feed
  var query = new google.gdata.calendar.CalendarEventQuery(feedUri);

  // Create and set the minimum and maximum start time for the date query
  var startMin = new google.gdata.DateTime( new Date() );
  // var startMax = new google.gdata.DateTime( new Date( +(new Date()) + (1000 * 60 * 60 * 24 * 30) ) );
  query.setMinimumStartTime(startMin);
  // query.setMaximumStartTime(startMax);
  query.setOrderBy('starttime');
  query.setSortOrder('ascending');
  query.setSingleEvents(true);
  query.setMaxResults(5);

  calendarService.getEventsFeed(query, callback, handleError);

});
