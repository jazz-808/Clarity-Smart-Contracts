
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.31.0/index.ts';
import { assertEquals, assertStringIncludes } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "update-employee-status set to false",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(5), types.bool(false)],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk().expectTuple()

        assertStringIncludes(result, `employeed: false`)
    },
});

Clarinet.test({
    name: "update-employee-status set to true",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(2), types.bool(true)],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk().expectTuple()

        assertStringIncludes(result, `employeed: true`)
    },
});

Clarinet.test({
    name: "update-employee-status when employee id does not exist",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(6), types.bool(true)],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectErr().expectAscii("ERR_EMPLOYEE_NOT_FOUND")
    },
});


Clarinet.test({
    name: "read-employee-status: of employee at the block height",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        chain.mineEmptyBlockUntil(250);

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(1), types.bool(false)],
                deployer    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 251);

        const readResponse = chain.callReadOnlyFn(
            "practice-map-keyword",
            "read-employee-status",
            [types.uint(1), types.uint(20)],
            deployer   
        )
        const result = readResponse.result
        result.expectOk().expectSome();

        assertStringIncludes(result, "employeed: true")
    },
});

Clarinet.test({
    name: "read-employee-status: of employee at the block height",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address

        chain.mineEmptyBlockUntil(20);

        let block1 = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(1), types.bool(false)],
                deployer    
            )
        ]);
        assertEquals(block1.receipts.length, 1);
        assertEquals(block1.height, 21);
        
        chain.mineEmptyBlockUntil(40);

        let block2 = chain.mineBlock([
            Tx.contractCall(
                "practice-map-keyword",
                "update-employee-status",
                [types.uint(1), types.bool(true)],
                deployer    
            )
        ]);
        assertEquals(block2.receipts.length, 1);
        assertEquals(block2.height, 41);

        const readResponse = chain.callReadOnlyFn(
            "practice-map-keyword",
            "read-employee-status",
            [types.uint(1), types.uint(22)],
            deployer   
        )

        const result = readResponse.result
        result.expectOk().expectSome();

        assertStringIncludes(result, "employeed: false")
    },
});
