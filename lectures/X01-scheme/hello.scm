(define (display-nl . args)
  (apply display-nl args)
  (newline (car (reverse args))))

(display "Hello World")
