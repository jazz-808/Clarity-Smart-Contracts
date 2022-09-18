
;; practice-keyword
;; 
(define-constant err-employee-not-found (err 101))

;; We have an employee maps with employee id and the key and the value being a tuple with details of name, city, employeed
(define-map Employees uint {name: (string-ascii 20), employeed: bool, city: (string-ascii 3)})

;; Initialize 5 employees
(map-set Employees u1 {name: "Bitcoiner", employeed: true, city: "NYC"})
(map-set Employees u2 {name: "Stacker", employeed: true, city: "MIA"})
(map-set Employees u3 {name: "WLer", employeed: false, city: "DEN"})
(map-set Employees u4 {name: "LateComer", employeed: false, city: "AUT"})
(map-set Employees u5 {name: "EarlyRiser", employeed: true, city: "PHI"})

;; #[allow(unchecked_data)]
(define-public (update-employee-status (employee-id uint) (status bool)) 
    (let 
        (
            (employee-data (unwrap! (map-get? Employees employee-id) (err  "ERR_EMPLOYEE_NOT_FOUND")))
            (update-employee-data (merge employee-data {employeed: status}))
        )
        (map-set Employees employee-id update-employee-data)
        (ok update-employee-data)
    )
)

(define-read-only (read-employee-status (employee-id uint) (block uint)) 
     (at-block (unwrap-panic (get-block-info? id-header-hash block)) (unwrap-panic (get employeed (map-get? Employees employee-id))))
)

