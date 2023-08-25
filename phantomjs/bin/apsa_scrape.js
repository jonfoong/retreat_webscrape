var webPage = require('webpage');
var url ='https://convention2.allacademic.com/one/apsa/apsa23/index.php?cmd=Online+Program+View+Selected+Session+Type+Submissions&selected_session_type_id=11507&program_focus=browse_by_session_type_submissions&PHPSESSID=cqeo68boc3va8bm08pu2d4ceov';
var fs = require('fs');
var page = webPage.create();
var system = require('system');

page.settings.userAgent = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)';

page.open(url, function (status) {
        setTimeout(function() {
               fs.write('rendered_page.html', page.content, 'w');
            phantom.exit();
    }, 2500);
});
