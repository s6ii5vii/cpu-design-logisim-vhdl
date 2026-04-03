# cpu-design-logisim-vhdl

Design and implementation of a **16-bit CPU in Logisim** and a **32-bit MIPS-style processor in VHDL**, including datapath design, ALU operations, control logic, simulations, and report documentation.

---

## Overview

This project explores CPU design using two approaches:

* **Logisim-evolution v4.1.0** for a visual 16-bit CPU implementation
* **VHDL** for a 32-bit MIPS-style processor implementation and simulation

---

## Project Structure

logisim/
├── project/        # Logisim circuit design files
├── report-ppt/     # Logisim PDF report + narrated PPT
└── screenshots/    # Logisim design screenshots

vhdl/
├── report-ppt/     # VHDL PDF report + narrated PPT
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

* Logisim-evolution v4.1.0
* VHDL
* GHDL
* GTKWave
* VS Code
* Git & GitHub

---

## Report

Final reports are available at:

logisim/report-ppt/Logisim_16bit_CPU_Report.pdf

vhdl/report-ppt/VHDL_CPU_REPORT.pdf

Narrated presentation files (with embedded slide audio) are available at:

logisim/report-ppt/16-Bit_CPU_Architecture0.pptx

vhdl/report-ppt/32-bit_MIPS_VHDL_Design1.pptx

---

## Learning Outcomes

* CPU datapath design
* Hardware modeling in VHDL
* Testbench creation
* Waveform debugging

---


