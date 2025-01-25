;; Evolution Parameters Contract

(define-map evolution-parameters (string-ascii 50) {
    value: uint,
    last-updated: uint
})

(define-data-var admin principal tx-sender)

(define-public (set-parameter (name (string-ascii 50)) (value uint))
    (begin
        (asserts! (is-eq tx-sender (var-get admin)) (err u403))
        (ok (map-set evolution-parameters name {
            value: value,
            last-updated: block-height
        }))
    )
)

(define-read-only (get-parameter (name (string-ascii 50)))
    (default-to
        { value: u0, last-updated: u0 }
        (map-get? evolution-parameters name)
    )
)

(define-public (transfer-admin (new-admin principal))
    (begin
        (asserts! (is-eq tx-sender (var-get admin)) (err u403))
        (ok (var-set admin new-admin))
    )
)

