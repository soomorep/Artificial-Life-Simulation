;; Quantum Life Form Contract

(define-data-var life-form-counter uint u0)

(define-non-fungible-token quantum-life-form uint)

(define-map life-forms uint {
    creator: principal,
    dna: (buff 32),
    energy: uint,
    generation: uint,
    last-evolution: uint
})

(define-public (create-life-form (dna (buff 32)))
    (let
        ((new-id (+ (var-get life-form-counter) u1)))
        (try! (nft-mint? quantum-life-form new-id tx-sender))
        (map-set life-forms new-id {
            creator: tx-sender,
            dna: dna,
            energy: u100,
            generation: u1,
            last-evolution: block-height
        })
        (var-set life-form-counter new-id)
        (ok new-id)
    )
)

(define-public (evolve-life-form (life-form-id uint) (new-dna (buff 32)))
    (let
        ((life-form (unwrap! (map-get? life-forms life-form-id) (err u404)))
         (owner (unwrap! (nft-get-owner? quantum-life-form life-form-id) (err u404))))
        (asserts! (is-eq tx-sender owner) (err u403))
        (asserts! (>= (- block-height (get last-evolution life-form)) u100) (err u429))
        (ok (map-set life-forms life-form-id
            (merge life-form {
                dna: new-dna,
                generation: (+ (get generation life-form) u1),
                last-evolution: block-height
            })))
    )
)

(define-public (transfer (life-form-id uint) (recipient principal))
    (let
        ((owner (unwrap! (nft-get-owner? quantum-life-form life-form-id) (err u404))))
        (asserts! (is-eq tx-sender owner) (err u403))
        (try! (nft-transfer? quantum-life-form life-form-id tx-sender recipient))
        (ok true)
    )
)

(define-read-only (get-life-form (life-form-id uint))
    (map-get? life-forms life-form-id)
)

(define-read-only (get-life-form-count)
    (var-get life-form-counter)
)

