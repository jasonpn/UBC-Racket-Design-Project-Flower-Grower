;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ubcdesignquiz3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; =================
;; Constants:

(define WIDTH 600)
(define HEIGHT 400)

(define CTR-Y (/ HEIGHT 2))
(define CTR-X (/ WIDTH 2))

(define MTS (empty-scene WIDTH HEIGHT "red"))

(define CENTER (circle 5 "solid" "black"))
(define FLOWER-IMG (overlay CENTER (circle 10 "solid" "white")))


;; =================
;; Data definitions:

(define-struct flower (x y size))
;; Flower is (make-flower Natural[0, WIDTH] Natural[0, HEIGHT] Number)
;; interp. a flower with x, y position and size in pixels
(define F0 (make-flower 0 0 0))
(define F1 (make-flower 100 100 10.5))
#;
(define (fn-for-flower f)
  (... (flower-x f)    
       (flower-y f)      
       (flower-size f)))

;; Template rules used:
;; Compound: 3 fields


;; =================
;; Functions:

;; Flower -> Flower
;; called to produce a growing flower animation; start with (main (make-flower CTR-X CTR-Y 0))
;; no tests for main function
(define (main f)
  (big-bang f
            (on-tick next-flower)      ; Flower -> Flower
            (to-draw render-flower)    ; Flower -> Image
            (on-mouse handle-mouse)))  ; Flower Natural[0, WIDTH] Natural[0, HEIGHT] MouseEvent -> Flower



;; Flower -> Flower
;; increase size of given flower by 0.1 pixels
(check-expect (next-flower (make-flower 0 0 0)) (make-flower 0 0 0.1))
(check-expect (next-flower (make-flower 10 10 10)) (make-flower 10 10 10.1))

;(define (next-flower f) f)   ;stub

;took template from Flower
(define (next-flower f)
  (make-flower (flower-x f) (flower-y f) (+ 0.1 (flower-size f))))



;; Flower -> Image
;; produce flower image at x and y position on MTS with given size
(check-expect (render-flower (make-flower 0 0 0)) (place-image empty-image 0 0 MTS))
(check-expect (render-flower (make-flower 100 100 10)) (place-image (scale 10 FLOWER-IMG) 100 100 MTS))
(check-expect (render-flower (make-flower (+ WIDTH 100) (+ HEIGHT 100) 10)) (place-image (scale 10 FLOWER-IMG) (+ WIDTH 100) (+ HEIGHT 100) MTS))

;(define (render-flower f) MTS)   ;stub

;took template from Flower
(define (render-flower f)
  (place-image (if (zero? (flower-size f))
                   empty-image
                   (scale (flower-size f) FLOWER-IMG))
               (flower-x f)
               (flower-y f)
               MTS))



;; Flower Natural[0, WIDTH] Natural[0, HEIGHT] MouseEvent -> Flower
;; produce new flower image at mouse click x and y position starting at size 0 
(check-expect (handle-mouse (make-flower 0 0 0) 100 100 "button-down") (make-flower 100 100 0))
(check-expect (handle-mouse (make-flower 100 100 10) 100 100 "button-up") (make-flower 100 100 10))
(check-expect (handle-mouse (make-flower 100 100 10) 400 300 "button-down") (make-flower 400 300 0))

;(define (handle-mouse f x y me) f)   ;stub

;took template from MouseEvent
(define (handle-mouse f x y me)
  (if (mouse=? me "button-down")
      (make-flower x y 0)
      f))
