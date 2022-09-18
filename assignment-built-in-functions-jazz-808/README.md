

# assignment-built-in-functions
Practice some Clarity built-in functions 

This assignment focuses not only the keywords & built in functions but also the other concepts in conjunction with that and that would be functions, contract calls and storing and retrieving data. 

There are 3 Contracts which need completing the implementation
1. `practice-tuple`
2. `practice-map-keyword`
3. `practice-contract-calls`

Each one of the above are different and need completing the implementation. 

-----------------------------------------------------------------------------
### 1. TASKS for Contract `practice-tuple`
There is a fixed input tuple for this task and it would be used to implement 2 functions in the contract `practice-tuple`:

``` {
    id: u1, 
    employee: {
        name: "Stacker", 
        city: "Windy City", 
        language: "Python", 
        clubs: (list {id: u10, name: "Club 1"}
                     {id: u20, name: "Club 2"} 
                     {id: u30, name: "Club 3"}
               )
    }
}
```

- [ ] **_Task 1_** 
- **TODO:** Implement the function `get-employee-2nd-club-name-from-tuple` which fetches the 2nd club name for the employee from the _INPUT_TUPLE_

- **Example Call:** (contract-call? .practice-tuple get-employee-2nd-club-name-from-tuple)
- **Result:** `(ok "Club 2")`


- [ ] **_Task 2_**: 

- **TODO:** Implement the function `set-new-language-in-tuple` which updates the language for the employee from the _INPUT_TUPLE_ by appending `Buidl` to it and returns the updated tuple in the response
NOTE: the tuple defined above is a constant so you do not need to update the constant value

- **Example Call:** (contract-call? .practice-tuple set-new-language-in-tuple)
- **Result:** 
```(ok {
        id: u1, 
        employee: {
            name: "Stacker", 
            city: "Windy City", 
            language: "PythonBuidl", 
            clubs: (list {id: u10, name: "Club 1"}
                         {id: u20, name: "Club 2"} 
                         {id: u30, name: "Club 3"}
                    )
        }
    }
)
```
**NOTE:** The response values will be same but your response might look different and that would only be because the tuple is unordered. Whichever order you provide to the tuple, it is unordered and orders itself in alphabetical order. 


-----------------------------------------------------------------------------
### 2. TASKS for Contract `practice-map-keyword`
There is a fixed map `Employees` for this task and it would be used to implement 2 functions in the contract `practice-map-keyword`. And 5 Employees have already been set on the map:

- [ ] ***Task 1***
- **TODO:** Implement the function `update-employee-status` to update the employee using the provided input of employee id and status which returns the updated employee map value. Another aspect to think about is what if the update function call is made with an employee id which does not exist. 
- **Example Call:** `(contract-call?  .practice-map-keyword update-employee-status u1  false)`

- **Result:**  `(ok  {name: "Bitcoiner", employeed: false, city: "NYC"})`

**Note:** you might see a different order of response - that is correct why because map value is a tuple and the tuple is unordered.

 - **Another Example Call:** `(contract-call?  .practice-map-keyword update-employee-status u10  false)`

 - **Result:** `(err  "ERR_EMPLOYEE_NOT_FOUND")` 
 This is because `u10` employee id does not exist in the Employees map.

So **DO NOT FORGET** to handle error scenarios and perform response handling.

- [ ] ***Task 2***
 - **TODO:** Implement the function `read-employee-status` which returns the status of the employee for the time (block) in the past.
- **Testing:** 
	- Initial status of employee u1 is true and initial block height is 1.
	- So advance the chain tip to a new block to 20, take a look at the clarinet console sub commands. 
	- Make the below call to update the employee data at block height of 20 now.

- **Sample Call:** `(contract-call?  .practice-map-keyword update-employee-status u1  false)`
- **Result:** `(ok  {name: "Bitcoiner", employeed: false, city: "NYC"})`
- **Further Testing:** 
	- Now the going forward the status of the empoyee u1 is false.
	- So advance the chain tip to a new block to 40
	- So make a Read Call at block height u19: `(contract-call?  .practice-map-keyword read-employee-status u1  u19)`
	- **Result:** `true`
	- So make another Read Call at block height u25: `(contract-call?  .practice-map-keyword read-employee-status u1  u25)`
	- **Result:** `false`
-----------------------------------------------------------------------------
### 3. TASKS for Contract `practice-contract-calls`
For this exercise, there is no shipment created, you would need to call `create-shipment` to test the 2 functions that you will implement. Before working on the contract implementation, understand what is happening in `example` contract.

-[ ] ***Task 1***
- **TODO:** Implement `update-shipment` (without changing the input parameters) and make a contract call to  `example` contract to update the shipment of the shipment id and return the response.

-[ ] ***Task 2***
- **TODO:** Implement `read-shipment` (without changing the input parameters) and make a contract call to `example` contract to read the shipment details of the shipment id and return the response.
