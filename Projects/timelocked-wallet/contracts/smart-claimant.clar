
;; smart-claimant
;; minimal ad hoc contract to act as beneficiary for timelocked-wallet contract

(define-public (claim)
    (begin
        (try! (as-contract (contract-call? .timelocked-wallet claim )))
        (let 
        (
            (total-balance (as-contract (stx-get-balance tx-sender)))
            (share (/ total-balance u4)) 
        )
        (try! (as-contract (stx-transfer? share tx-sender 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)))
        (try! (as-contract (stx-transfer? share tx-sender 'ST3PF13W7Z0RRM42A8VZRVFQ75SV1K26RXEP8YGKJ)))
        (try! (as-contract (stx-transfer? share tx-sender 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP)))
        (try! (as-contract (stx-transfer? share tx-sender 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0)))
        (ok true)
        )
    )
)
