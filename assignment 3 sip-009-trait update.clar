
;; my-nft

;; IMPLEMENT TRAIT HERE
(impl-trait .sip-009-trait.nft-trait)

;; DEFINE NON-FUNGIBLE-TOKEN HERE
(define-non-fungible-token planties uint)

(define-constant MINT_PRICE u1000000)
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_OWNER_ONLY (err u100))
(define-constant ERR_NOT_TOKEN_OWNER (err u101))

(define-data-var last-token-id uint u0)

;; WRITE get-last-token-id FUNCTION HERE
(define-read-only (get-last-token-id)
 (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (id uint)) 
  (ok none)
)

(define-read-only (get-owner (id uint))
  ;; COMPLETE THIS FUNCTION HERE
    (ok (nft-get-owner? planties id))
)

;; WRITE transfer FUNCTION HERE
(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) ERR_NOT_TOKEN_OWNER)
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
    ;; COMPLETE THIS FUNCTION HERE
    (asserts! (is-eq tx-sender recipient) ERR_OWNER_ONLY)
    (try! (stx-transfer? MINT_PRICE recipient CONTRACT_OWNER))
    (try! (nft-mint? planties id recipient))
    (var-set last-token-id id)
    (ok id)
  )
)

;; WRITE mint-five FUNCTION HERE
(define-public (mint-five (recipient principal))
  (let 
    (
      (id (+ (var-get last-token-id) u1))
    )
    ;; COMPLETE THIS FUNCTION HERE
    (asserts! (is-eq tx-sender recipient) ERR_OWNER_ONLY)
    (try! (stx-transfer? (* MINT_PRICE u5) recipient CONTRACT_OWNER))
    (try! (nft-mint? planties (+ id u1) recipient))
    (try! (nft-mint? planties (+ id u2) recipient))
    (try! (nft-mint? planties (+ id u3) recipient))
    (try! (nft-mint? planties (+ id u4) recipient))
    (try! (nft-mint? planties (+ id u5) recipient))
    (var-set last-token-id (+ id u5))
    (ok id)
  )
)