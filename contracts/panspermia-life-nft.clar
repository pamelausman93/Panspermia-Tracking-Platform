;; Panspermia Life Form NFT Contract

(define-non-fungible-token panspermia-life-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
    creator: principal,
    life-form-name: (string-ascii 100),
    origin-planet: (string-ascii 50),
    genetic-complexity: uint,
    adaptability-score: uint,
    creation-date: uint
})

(define-public (mint-life-form-nft (life-form-name (string-ascii 100)) (origin-planet (string-ascii 50)) (genetic-complexity uint) (adaptability-score uint))
    (let
        ((new-id (+ (var-get token-id-counter) u1)))
        (try! (nft-mint? panspermia-life-nft new-id tx-sender))
        (map-set token-metadata new-id {
            creator: tx-sender,
            life-form-name: life-form-name,
            origin-planet: origin-planet,
            genetic-complexity: genetic-complexity,
            adaptability-score: adaptability-score,
            creation-date: block-height
        })
        (var-set token-id-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? panspermia-life-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get token-id-counter)
)

