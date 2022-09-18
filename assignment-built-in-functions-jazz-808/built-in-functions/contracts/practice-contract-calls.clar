
;; practice-contract-calls
;; 

(define-public (create-shipment)
    (let 
        (
            (caller tx-sender)
        )
        (as-contract (contract-call? .example create-shipment caller))
    )
)

(define-public (update-status (shipment-id uint) (status (string-ascii 10)))
    (let 
        (
            (caller tx-sender)
        )
        (as-contract (contract-call? .example update-status shipment-id status caller))
    )
)

(define-read-only (read-shipment (shipment-id uint))
    (let 
        (
            (caller tx-sender)
        )
        (as-contract (contract-call? .example read-shipment shipment-id caller))
    )
)
