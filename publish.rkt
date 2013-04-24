#lang racket/base
(require racket/date
         racket/match
         racket/system
         "render-post.rkt")

(with-handlers
    ([exn:misc:match?
      (λ (_)
        (displayln "usage: racket publish.rkt technical|freedom name"))])
  (match-let ([(vector strand name) (current-command-line-arguments)])
    (define draft-path (format "~a/drafts/~a.txt" strand name))
    (define hierarchy
      (let ([now (current-date)])
        (format "~a/~a/~a" (date-year now) (date-month now) (date-day now))))
    (define final-path (format "~a/~a/~a.txt" strand hierarchy name))
    (define post-path (format "~a/~a/~a.html" strand hierarchy name))
    (if (file-exists? draft-path)
        (begin
          (system "git checkout source")
          (system (format "mkdir -p ~a/~a" strand hierarchy))
          (system (format "git add ~a" draft-path))
          (system (format "git mv ~a ~a" draft-path final-path))
          (system (format "git commit -m \"Publish ~a.\"" name))
          (let ([post (render-post final-path)])
            (system "git checkout master")
            (system (format "mkdir -p ~a/~a" strand hierarchy))
            (with-output-to-file post-path
              (λ () (write post)))
            (system (format "git add ~a" post-path))
            (system (format "git commit -m \"Publish ~a.\"" name))
            #;(system "git push origin source")
            #;(system "git push")))
        (printf "path ~a does not exist.\n" draft-path))))
