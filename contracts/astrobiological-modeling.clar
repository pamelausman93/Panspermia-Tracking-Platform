;; Astrobiological Modeling Contract

(define-data-var model-counter uint u0)

(define-map astrobiological-models uint {
    creator: principal,
    planet: (string-ascii 50),
    atmospheric-composition: (string-utf8 500),
    temperature-range: (string-ascii 50),
    gravity: uint,
    radiation-levels: uint,
    adaptability-prediction: uint,
    potential-life-forms: (string-utf8 1000),
    created-at: uint
})

(define-public (create-astrobiological-model (planet (string-ascii 50)) (atmospheric-composition (string-utf8 500)) (temperature-range (string-ascii 50)) (gravity uint) (radiation-levels uint) (adaptability-prediction uint) (potential-life-forms (string-utf8 1000)))
    (let
        ((new-id (+ (var-get model-counter) u1)))
        (map-set astrobiological-models new-id {
            creator: tx-sender,
            planet: planet,
            atmospheric-composition: atmospheric-composition,
            temperature-range: temperature-range,
            gravity: gravity,
            radiation-levels: radiation-levels,
            adaptability-prediction: adaptability-prediction,
            potential-life-forms: potential-life-forms,
            created-at: block-height
        })
        (var-set model-counter new-id)
        (ok new-id)
    )
)

(define-public (update-astrobiological-model (model-id uint) (new-adaptability-prediction uint) (new-potential-life-forms (string-utf8 1000)))
    (let
        ((model (unwrap! (map-get? astrobiological-models model-id) (err u404))))
        (asserts! (is-eq tx-sender (get creator model)) (err u403))
        (ok (map-set astrobiological-models model-id
            (merge model {
                adaptability-prediction: new-adaptability-prediction,
                potential-life-forms: new-potential-life-forms
            })))
    )
)

(define-read-only (get-astrobiological-model (model-id uint))
    (map-get? astrobiological-models model-id)
)

(define-read-only (get-model-count)
    (var-get model-counter)
)

