# cpu-design-logisim-vhdl

Design and implementation of a **16-bit CPU in Logisim** and a **32-bit MIPS-style processor in VHDL**, including datapath design, ALU operations, control logic, simulations, and report documentation.

---

## Overview

This project explores CPU design using two approaches:

* **Logisim** for a visual 16-bit CPU implementation
* **VHDL** for a 32-bit MIPS-style processor implementation and simulation

---

## Project Structure

vhdl/
├── report/         # Final VHDL report (PDF)
├── screenshots/    # GTKWave waveform screenshots
├── simulations/    # Simulation output files (.vcd)
├── src/            # VHDL source files
└── testbench/      # VHDL testbenches

---

## Logisim Section

The Logisim portion focuses on a **16-bit CPU design**, including:

* ALU operations
* Datapath connections
* Basic instruction execution

This helps visualize how CPU components interact before implementing them in VHDL.

---

## VHDL Section

The VHDL implementation models a **32-bit MIPS-style processor** with:

* ALU
* Data Memory
* Register File
* Instruction Memory
* Control Unit
* CPU Top Module

Each component was tested using a testbench and waveform simulation.

---

## Completed Tasks

### Task 1 — Component Implementation

All CPU components implemented in 32-bit VHDL with testbenches.

### Task 2 — ALU Operations

Addition, subtraction, AND, OR, and comparison verified.

### Task 3 — Register File

Registers written and read successfully.

### Task 4 — Instruction Memory

MIPS instructions encoded and retrieved correctly.

### Task 5 — Control Unit

Correct control signals generated for required instructions.

---

## Simulations

Simulations were performed using:

* **GHDL**
* **GTKWave**

Waveforms are included in:

vhdl/screenshots/

Simulation files:

vhdl/simulations/

---

## CPU Integration

A full CPU simulation demonstrates:

* Program Counter increment
* Instruction execution flow
* ALU operations
* Register read/write
* Clock-driven behavior

---

## Tools Used

* Logisim
* VHDL
* GHDL
* GTKWave
* VS Code
* Git & GitHub

---

## Report

The full report is available at:

vhdl/report/VHDL-IMPLEMENTATION-AND-SIMULATION.pdf

---

## Learning Outcomes

* CPU datapath design
* Hardware modeling in VHDL
* Testbench creation
* Waveform debugging

---


