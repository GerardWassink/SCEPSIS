
# SCEPSIS

## Instructions as a combination of Control Signals

Now that all Control Signals have been defined we can think of ways to combine them to have the computer do what we want it to do.

### An example

As an example we will describe a simple instruction that will get the value that has been input by the user and put it memory location 42. We call this instruction I2M (Input to Memory). This instruction would read:

	I2M 42

#### The fetch phase

The first thing for every instruction is that we have to ***fetch*** the actual instruction from memory. As we shall see this incorporates the use of several Control Signals in subsequent microcode steps.

The fetch phase is exactly the same for every instruction. This is the combination of Control Signals for the fetch phase:

##### microcode for the fetch phase

- Clock Cycle 1 - PCTO + MARI - *put the value of the PCT in the MAR*
- Clock Cycle 2 - RAMO + INRI + CE - *put the value out of memory into the INR and bump the PCT up by 1*

Now, after two clock ticks, we have read the value out of memory (pointed to by the Program Counter), that is the value of the next instruction, into the Instruction Register from where it can be decoded; lastly, we had the PCT point to the next instruction.

#### The decode phase

In our little CPU there will not be microcode for the ***decode*** phase. We assume that the **INR** is connected to the decode logic, which will in its turn produce the microcode needed to perform the instruction.

#### The get data phase

The ***get data*** phase will take care of obtaining the data that is needed for the execution of our instruction, whether it be from a register, from memory or from the outside world. 

In this case it will get the address from memory, it is stored right after the instruction, so we need the **PCT** for that (remember we bumped it at the end of the fetch phase?). After use we have to make sure to bump it again to point to the next instruction!

##### microcode for the get data phase

- Clock Cycle 3 - PCTO + MARI - *put value from the PCT on the DAB and read the value into the MAR*
- Clock Cycle 4 - MEMO + MARI + CE - *put value from the input register on the DAB and have MEM read it in into the proper location; then bump the PCT again*

The MAR, which is now pointing to location 42, is used in step 4 to retrieve the address where INP has to be stored.

#### The execute phase

In this case, the ***execute*** phase will get the data from the input register, and put it into memory at the desired location.

##### microcode for the execute phase

- Clock Cycle 5 - INPO + MEMI + CE - *put value from the input register on the DAB and have MEM read it in into the proper location; then bump the PCT again*

### langdef file

We would code this I2M instruction in the scepsis.langdef file as follows:

<pre>
 #
 # I2M {address} - put the value from the INP register into memory location {address]
 xx I2M PCTO MARI - MEMO INRI CE - PCTO MARI - MEMO MARI - INPO MEMI CE
</pre>



### Further reading

- [README file for SCEPSIS](../README.md)
- [Components of the SCEPSIS CPU](./Components.md)
- [Diagram of SCEPSIS components](../gfx/SCEPSIS_Components.JPG)
- [Control signals in the SCEPSIS CPU](./ControlSignals.md)
- [Example instruction for the SCEPSIS CPU](./Example.md)
- [Language definition for the SCEPSIS CPU](./Langdef.md)
- [ALU instructions for the SCEPSIS CPU](./ALUinstructions.md)

