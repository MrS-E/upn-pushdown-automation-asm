# README UPN Kellerautomat (C + Assembly)

## Overview

This program implements a **deterministic pushdown automaton (Kellerautomat)** for evaluating UPN (Reverse Polish Notation).

- **Input/Output:** implemented in C
- **Core logic:** implemented in **x86-64 assembly**
- **Stack:** uses the **CPU stack (`rsp`)**

## Assembly Details

- **Architecture:** x86-64 (AMD64)
- **Syntax:** Intel (`.intel_syntax noprefix`)
- **ABI:** System V AMD64

### Registers used

- `rsp` -> PDA stack (real machine stack)
- `rbx` -> input pointer
- `r12d` -> mode (run / step)
- `r13` -> result pointer
- `r14` -> saved C stack pointer (for function calls)
- `r15` -> lower bound of reserved stack region

## Program Flow

1. Read input string (C)
2. Call assembly function `evaluate_upn_asm`
3. For each symbol:
   - digit -> push onto stack (`rsp`)
   - operator -> pop 2 values, compute, push result
4. Optional step mode:
   - temporarily switch stack
   - call C function to print stack
5. Accept if exactly one value remains -> return result

## Notes

- The automaton is **deterministic**
- The stack is implemented using the **actual processor stack**
- Step mode uses controlled **stack switching** for safe C calls
