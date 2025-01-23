;; Evolutionary Divergence Contract

(define-data-var divergence-counter uint u0)

(define-map evolutionary-divergences uint {
    colonization-id: uint,
    new-species: (string-ascii 100),
    divergence-factor: uint,
    environmental-pressures: (string-utf8 500),
    time-elapsed: uint,
    status: (string-ascii 20)
})

(define-public (record-evolutionary-divergence (colonization-id uint) (new-species (string-ascii 100)) (divergence-factor uint) (environmental-pressures (string-utf8 500)) (time-elapsed uint))
    (let
        ((new-id (+ (var-get divergence-counter) u1)))
        (map-set evolutionary-divergences new-id {
            colonization-id: colonization-id,
            new-species: new-species,
            divergence-factor: divergence-factor,
            environmental-pressures: environmental-pressures,
            time-elapsed: time-elapsed,
            status: "recorded"
        })
        (var-set divergence-counter new-id)
        (ok new-id)
    )
)

(define-public (update-divergence-status (divergence-id uint) (new-status (string-ascii 20)))
    (let
        ((divergence (unwrap! (map-get? evolutionary-divergences divergence-id) (err u404))))
        (ok (map-set evolutionary-divergences divergence-id
            (merge divergence { status: new-status })))
    )
)

(define-read-only (get-evolutionary-divergence (divergence-id uint))
    (map-get? evolutionary-divergences divergence-id)
)

(define-read-only (get-divergence-count)
    (var-get divergence-counter)
)

