
;; counter
;; multiplayer counter contract

;; map to store the individual counter values
(define-map counters principal uint)

;;returns counter value for a specified principal
(define-read-only (get-count (who principal))
 (default-to u0 (map-get? counters who))
)

;; function that will increment the counter for tx-sender
(define-public (count-up) 
 (ok (map-set counters tx-sender (+ (get-count tx-sender) u1)))
)