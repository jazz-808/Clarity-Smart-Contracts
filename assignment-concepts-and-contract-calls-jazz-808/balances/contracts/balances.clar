
;; balances
;; contract to practice the basic Clarity concepts and testing within the console

;; constants
(define-constant CALLER tx-sender)

;; data maps and vars
(define-data-var total-transfers uint u0)

;;balance for coresponding principal/wallet
(define-map balances principal uint)

;;Retrieve STX balance
(define-read-only (get-balances (address principal))
 (default-to (stx-get-balance address) (map-get? balances address))
)

(define-read-only (get-total-transfers)
 (var-get total-transfers)
)

(define-public (transfer (amount uint) (recipient principal)) 
    (begin
        (try! (stx-transfer? amount tx-sender recipient))
        (var-set total-transfers (+ (var-get total-transfers) u1))
        (ok true) 
    )
)
