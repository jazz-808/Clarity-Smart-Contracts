
;; timelocked-wallet
;; wallet contract that unlocks at a specific block height

;;owner
(define-constant contract-owner tx-sender)

;;errors
(define-constant err-owner-only (err u100)) ;;someone other than contract owner called lock
(define-constant err-already-locked (err u101)) ;;contract owner tried to call lock more than once
(define-constant err-unlock-in-past (err u102)) ;;passed unlock height is in the past
(define-constant err-no-value (err u103)) ;;owner called lock with an initial deposit of u0
(define-constant err-beneficiary-only (err u104)) ;;somebody other than the beneficiary called claim or lock
(define-constant err-unlock-height-not-reached (err u105)) ;;beneficiary called claim but unlock height has not been reached

;;data
(define-data-var beneficiary (optional principal) none)
(define-data-var unlock-height uint u0)

;; implementing lock
(define-public (lock (new-beneficiary principal) (unlock-at uint) (amount uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-none (var-get beneficiary)) err-already-locked)
        (asserts! (> unlock-at block-height) err-unlock-in-past)
        (asserts! (> amount u0) err-no-value)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (var-set beneficiary (some new-beneficiary))
        (var-set unlock-height unlock-at)
        (ok true)
    )
)

;; allows beneficiary to transfer the right to claim the wallet
(define-public (bestow (new-beneficiary principal))
    (begin
        (asserts! (is-eq (some tx-sender) (var-get beneficiary)) err-beneficiary-only)
        (var-set beneficiary (some new-beneficiary))
        (ok true)
    ) 
)

;;transfers tokens to the tx-sender if the unlock height has been reached and if the tx-sender is equal to the beneficiary
(define-public (claim)
    (begin
        (asserts! (is-eq (some tx-sender) (var-get beneficiary)) err-beneficiary-only)
        (asserts! (>= block-height (var-get unlock-height)) err-unlock-height-not-reached)
        (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender (unwrap-panic (var-get beneficiary))))
    )
)