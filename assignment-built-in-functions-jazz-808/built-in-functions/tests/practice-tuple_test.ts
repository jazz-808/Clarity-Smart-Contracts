
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.31.0/index.ts';
import { assertEquals, assertStringIncludes } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "get-employee-2nd-club-name-from-tuple",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-tuple",
                "get-employee-2nd-club-name-from-tuple",
                [],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk();

        assertEquals(result, `(ok "Club 2")`)
    },
});

Clarinet.test({
    name: "set-new-language-for-employee-in-tuple",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-tuple",
                "set-new-language-for-employee-in-tuple",
                [],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk().expectTuple()

        assertStringIncludes(result, `language: "PythonBuidl"`)
    },
});
