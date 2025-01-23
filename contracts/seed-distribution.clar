;; Seed Distribution Management Contract

(define-data-var seed-counter uint u0)

(define-map seed-distributions uint {
    creator: principal,
    origin: (string-ascii 50),
    target-system: (string-ascii 50),
    seed-type: (string-ascii 100),
    launch-date: uint,
    estimated-arrival: uint,
    status: (string-ascii 20)
})

(define-public (launch-seed-distribution (origin (string-ascii 50)) (target-system (string-ascii 50)) (seed-type (string-ascii 100)) (estimated-arrival uint))
    (let
        ((new-id (+ (var-get seed-counter) u1)))
        (map-set seed-distributions new-id {
            creator: tx-sender,
            origin: origin,
            target-system: target-system,
            seed-type: seed-type,
            launch-date: block-height,
            estimated-arrival: estimated-arrival,
            status: "launched"
        })
        (var-set seed-counter new-id)
        (ok new-id)
    )
)

(define-public (update-seed-status (seed-id uint) (new-status (string-ascii 20)))
    (let
        ((distribution (unwrap! (map-get? seed-distributions seed-id) (err u404))))
        (asserts! (is-eq tx-sender (get creator distribution)) (err u403))
        (ok (map-set seed-distributions seed-id
            (merge distribution { status: new-status })))
    )
)

(define-read-only (get-seed-distribution (seed-id uint))
    (map-get? seed-distributions seed-id)
)

(define-read-only (get-seed-count)
    (var-get seed-counter)
)

