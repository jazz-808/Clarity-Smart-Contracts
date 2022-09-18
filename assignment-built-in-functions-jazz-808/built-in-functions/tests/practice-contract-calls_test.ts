
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.31.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "update-shipment: successfully",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-contract-calls",
                "create-shipment",
                [],
                shipper    
            ),
            Tx.contractCall(
                "practice-contract-calls",
                "update-shipment",
                [types.uint(1), types.ascii("shipped")],
                shipper    
            )
        ]);
        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 2);

        const result = block.receipts[1].result
        result.expectOk().expectBool(true)
        
        const blockRead = chain.callReadOnlyFn(
            "practice-contract-calls",
            "read-shipment",
            [types.uint(1)],
            shipper
        )

        assertEquals(blockRead.result, `(some {recipient: ${shipper}, status: "shipped"})`)
    },
});

Clarinet.test({
    name: "update-shipment: does not update successfully as shipment id does not exist",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-contract-calls",
                "update-shipment",
                [types.uint(1), types.ascii("shipped")],
                shipper    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectErr().expectAscii("ERR_SHIPMENT_NOT_FOUND")
        
    },
});

Clarinet.test({
    name: "update-shipment: does not update successfully as shipment update call was not made by the original shipper",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address
        const another_shipper = accounts.get("wallet_2")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-contract-calls",
                "create-shipment",
                [],
                shipper    
            ),
            Tx.contractCall(
                "practice-contract-calls",
                "update-shipment",
                [types.uint(1), types.ascii("shipped")],
                another_shipper    
            )
        ]);
        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 2);

        const result = block.receipts[1].result
        result.expectErr().expectAscii("ERR_SHIPMENT_NOT_FOUND")
        
    },
});

Clarinet.test({
    name: "read-shipment: successfully",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-contract-calls",
                "create-shipment",
                [],
                shipper    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk()
        
        const blockRead = chain.callReadOnlyFn(
            "practice-contract-calls",
            "read-shipment",
            [types.uint(1)],
            shipper
        )

        assertEquals(blockRead.result, `(some {recipient: ${shipper}, status: "Pending"})`)
    },
});

Clarinet.test({
    name: "read-shipment: when not the shipper",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address
        const another_shipper = accounts.get("wallet_2")!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "practice-contract-calls",
                "create-shipment",
                [],
                shipper    
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const result = block.receipts[0].result
        result.expectOk()
        
        const blockRead = chain.callReadOnlyFn(
            "practice-contract-calls",
            "read-shipment",
            [types.uint(1)],
            another_shipper
        )

        assertEquals(blockRead.result, `none`)
    },
});

Clarinet.test({
    name: "read-shipment: when no shipment available",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const shipper = accounts.get("wallet_1")!.address

        const blockRead = chain.callReadOnlyFn(
            "practice-contract-calls",
            "read-shipment",
            [types.uint(1)],
            shipper
        )

        assertEquals(blockRead.result, `none`)
    },
});
