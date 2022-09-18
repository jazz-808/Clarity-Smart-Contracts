
;; example
;; 

(define-constant RECIPIENT 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)

(define-map Shipment {id: uint, shipper: principal} {status: (string-ascii 12), recipient: principal})

(define-data-var last-shipment-id uint u0)

(define-public (create-shipment (caller principal)) 
    (let
        (
            (next-id (+ (var-get last-shipment-id) u1))
        )
        (map-set Shipment {id: next-id, shipper: caller} {status: "Pending", recipient: RECIPIENT})
        (var-set last-shipment-id next-id)
        (print caller)
        (ok next-id)
    )
)

(define-public (update-status (shipment-id uint) (status (string-ascii 10)) (caller principal)) 
    (let
        (
            (shipmentValue (unwrap! (map-get? Shipment {id: shipment-id, shipper: caller}) (err "ERR_SHIPMENT_NOT_FOUND")))
            (updatedValue (merge shipmentValue {status: status}))
        )
        (print caller)
        (ok (map-set Shipment {id: shipment-id, shipper: caller} updatedValue))
    )
)

(define-read-only (read-shipment (shipment-id uint) (caller principal)) 
    (map-get? Shipment {id: shipment-id, shipper: caller})
)
