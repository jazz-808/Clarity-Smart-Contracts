
;; planties-nft

(impl-trait .sip009-nft-trait.nft-trait)

;; SIP009 NFT trait on mainnet
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

(define-non-fungible-token planties uint)

(define-data-var last-token-id uint u0)

(define-read-only (get-last-token-id)
 (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
 (ok none)
)

(define-read-only (get-owner (token-id uint))
 (ok (nft-get-owner? planties token-id))
)

(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin
         (asserts! (is-eq tx-sender sender) err-not-token-owner)
         ;; #[filter (id, recipient)]
         (try! (nft-transfer? planties id sender recipient))
         (ok true)
    )
)

(define-public (mint (recipient principal))
    (let
        (
            (id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (try! (nft-mint? planties id recipient))
        (var-set last-token-id id)
        (ok id)
    )
)
