#lang racket/base
(require racket/file
         racket/list
         racket/string)

(provide render-post)

(define (render-post path)
  (define lines (file->lines path))
  (define title (first lines))
  (define keywords (string-split (second lines)))
  (define body (string-join (rest (rest lines)) "\n"))
  (format "\
<!DOCTYPE html>
<html>

<head>
<title>~a</title>
<link rel=\"stylesheet\" href=\"/style.css\"/>
~a
</head>

<body>
<h1>~a</h1>
<hr/>
~a
~a
</body>

</html>
" title
  (google-analytics-code)
  title
  body
  (disqus-code title)))

(define (google-analytics-code) "\
<script type=\"text/javascript\">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-40150784-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>\
")

(define (disqus-code title)
  (format "\
<script type=\"text/javascript\">
  var disqus_shortname = 'kimballgermanenet';
  var disqus_id = '~a';

 (function() {
   var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
   dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
   (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
 })();
</script>\
" title))
