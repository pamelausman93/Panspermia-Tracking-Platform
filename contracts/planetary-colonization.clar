;; Planetary Colonization Contract

(define-data-var colonization-counter uint u0)

(define-map colonization-events uint {
    seed-id: uint,
    planet: (string-ascii 50),
    colonization-date: uint,
    success-probability: uint,
    dominant-life-form: (string-ascii 100),
    status: (string-ascii 20)
})

(define-public (record-colonization-event (seed-id uint) (planet (string-ascii 50)) (success-probability uint) (dominant-life-form (string-ascii 100)))
    (let
        ((new-id (+ (var-get colonization-counter) u1)))
        (map-set colonization-events new-id {
            seed-id: seed-id,
            planet: planet,
            colonization-date: block-height,
            success-probability: success-probability,
            dominant-life-form: dominant-life-form,
            status: "initial"
        })
        (var-set colonization-counter new-id)
        (ok new-id)
    )
)

(define-public (update-colonization-status (event-id uint) (new-status (string-ascii 20)))
    (let
        ((event (unwrap! (map-get? colonization-events event-id) (err u404))))
        (ok (map-set colonization-events event-id
            (merge event { status: new-status })))
    )
)

(define-read-only (get-colonization-event (event-id uint))
    (map-get? colonization-events event-id)
)

(define-read-only (get-colonization-count)
    (var-get colonization-counter)
)

