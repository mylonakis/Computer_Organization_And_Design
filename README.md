# Top Level view of the Microprocessor's datapath.
![datapath](https://github.com/user-attachments/assets/daf60c2d-c928-41ec-8c56-a8f603c750e3)

# Testbech results verifying the correctness of the circuit.
![testbench](https://github.com/user-attachments/assets/59711edf-67d8-4d8d-9e11-e0182d3e4e51)

Commands executed for testing:             <br />
1: addi r1, r0, 10 -- r1 = 10              <br />  
2: addi r2, r0, 20 -- r2 = 20              <br />
3: add r3, r1, r2  -- r3 = 30              <br />
4: sw r3, 4(r0)    -- ram[1028] = 30       <br />
5: nand r4, r3, r1 -- r4 = fffffff5        <br />
6: sub r5, r4, r1  -- r5 = ffffffeb        <br />
7: sb r4, 8(r0)    -- ram[1032]= 000000f5  <br />
