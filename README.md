# Beginner ATM (x86-64 NASM)

A small command-line "ATM" program written in x86-64 assembly. Supports balance, deposit,
withdraw, and exit.

## Known bugs

- Command comparison only checks the first 2 bytes of input, not the whole word — can misfire
  on inputs that share a prefix.
  
- Negative balance isn't handled correctly when converting to ASCII for display.
- No input validation on deposit/withdraw amounts (negative numbers, non-numeric input,
  overdrawing the balance).
  
- No bounds checking on the input buffers.
