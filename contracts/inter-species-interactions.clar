;; Inter-species Interactions Contract

(define-map interactions uint {
    life-form-1: uint,
    life-form-2: uint,
    interaction-type: (string-ascii 20),
    result: (string-ascii 50),
    timestamp: uint
})

(define-data-var interaction-counter uint u0)

(define-public (record-interaction (life-form-1 uint) (life-form-2 uint) (interaction-type (string-ascii 20)) (result (string-ascii 50)))
    (let
        ((new-id (+ (var-get interaction-counter) u1)))
        (map-set interactions new-id {
            life-form-1: life-form-1,
            life-form-2: life-form-2,
            interaction-type: interaction-type,
            result: result,
            timestamp: block-height
        })
        (var-set interaction-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-interaction (interaction-id uint))
    (map-get? interactions interaction-id)
)

(define-read-only (get-interaction-count)
    (var-get interaction-counter)
)

