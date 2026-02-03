# 📐 Polyline Language Parser

![Compiler](https://img.shields.io/badge/Compiler-Project-blue)
![C](https://img.shields.io/badge/C-00599C?style=flat&logo=c&logoColor=white)
![Lex](https://img.shields.io/badge/Lex-Parser-orange)
![Yacc](https://img.shields.io/badge/Yacc-Grammar-green)
![Status](https://img.shields.io/badge/Status-Complete-success)

> **📚 Academic Project**: Compiler Lab Course - University of Verona, A.Y. 2023-2024

---

## 🎯 Project Overview

This project implements a **complete compiler** for a domain-specific language (DSL) dedicated to the definition and manipulation of **polylines**. Built using **Lex** and **Yacc**, the parser analyzes and interprets geometric commands to create, manipulate, and query polyline structures in a 2D Cartesian plane.

### What is a Polyline?

A **polyline** is a sequence of contiguous linear segments connecting multiple points. The polyline can be:
- **Closed**: When the initial and final points coincide
- **Open**: When the endpoints are different

### Main Components

| Component | Description |
|-----------|-------------|
| **Lexer** (`lexer.l`) | Tokenizes input commands and identifies language elements |
| **Parser** (`parser.y`) | Main parser with full feature set (operations, variables) |
| **AST Parser** (`parserPlus.y`) | Extended parser that generates Abstract Syntax Trees |
| **Makefile** | Automated build system for both executables |

---

## ✨ Features

### 📍 Polyline Definition
- Define polylines by specifying an **arbitrary number of points**
- Points represented as **floating-point coordinates** for precision
- Syntax: `(x1,y1) (x2,y2) (x3,y3) ...`

### 🔄 Symmetry Operations
Generate points through symmetry transformations:

| Operation | Description | Example |
|-----------|-------------|---------|
| `sim0(x,y)` | Symmetry with respect to **origin** | `sim0(3,4)` → `(-3,-4)` |
| `simx(x,y)` | Symmetry with respect to **x-axis** | `simx(3,4)` → `(3,-4)` |
| `simy(x,y)` | Symmetry with respect to **y-axis** | `simy(3,4)` → `(-3,4)` |

### 🔍 Query Operations
- **`isOpen`**: Check if a polyline is open or closed
- **`length`**: Calculate total length of all segments
- **`close`**: Close an open polyline and compute perimeter

### 💾 Variable Storage
- **Save polylines** in named variables
- **Reuse saved polylines** for operations
- **Concatenate polylines** using binary addition

### 🌳 Abstract Syntax Tree
- Generate complete **AST representation** of input
- Visualize **hierarchical structure** of commands
- Display **depth information** for each node

---

## 🏗️ Architecture

```
┌─────────────────┐
│   Input Text    │
│   (Polyline     │
│    Language)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Lexer (Lex)   │
│   Tokenization  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Parser (Yacc)  │
│   Syntax        │
│   Analysis      │
└────────┬────────┘
         │
         ├──────────────────┬──────────────────┐
         ▼                  ▼                  ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   Operations    │ │   Variables     │ │   AST Output    │
│   (isOpen,      │ │   (Storage &    │ │   (Tree         │
│    close, etc)  │ │    Retrieval)   │ │    Structure)   │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

---
## 🛠️ Requirements

### System Requirements

| Component | Required |
|-----------|----------|
| **Operating System** | Linux (tested on Ubuntu/Debian) |
| **Flex** | Lexical analyzer generator |
| **Bison** | Parser generator (Yacc compatible) |
| **GCC** | C compiler |
| **Make** | Build automation tool |

### Installation

Install required packages on Debian/Ubuntu systems:

```bash
sudo apt-get install flex bison build-essential
```

---
## 🚀 Compilation & Execution

### Build Process

Navigate to the project directory and run:

```bash
make
```

This generates **two executables**:

| Executable | Description | Features |
|------------|-------------|----------|
| `elaborato` | **Standard version** | Full feature set: operations, variables, calculations |
| `elaboratoPlus` | **AST version** | Abstract Syntax Tree generation and visualization |

### Running the Programs

**Standard version** (full features):
```bash
./elaborato
```

**AST version** (tree visualization):
```bash
./elaboratoPlus
```

### Cleaning Build Files

```bash
make clean
```

---

## 📝 Commands and Examples

### Standard Version (`./elaborato`)

#### 1️⃣ Basic Polyline Creation
Create a temporary polyline and display its length:

![Creating polyline](images/elab1.png)

#### 2️⃣ Symmetry Operations
Create polyline using symmetric coordinates (`sim0`, `simx`, `simy`):

![Symmetry operations](images/elab2.png)

#### 3️⃣ Open/Closed Check
Verify if a polyline is open:

![isOpen check](images/elab3.png)

#### 4️⃣ Close Operation
Close an open polyline and display perimeter:

![Close polyline](images/elab4.png)

#### 5️⃣ Variable Storage
Save polyline in a variable and retrieve its length:

![Variable storage](images/elab5.png)

#### 6️⃣ Query Saved Polylines
Check if a saved polyline is open:

![Query variable](images/elab6.png)

#### 7️⃣ Close and Store
Assign the closure of a polyline to a variable:

![Close and store](images/elab7.png)

#### 8️⃣ Polyline Concatenation
Combine two saved polylines into a new one:

![Concatenation](images/elab8.png)



### AST Version (`./elaboratoPlus`)

The AST version generates and displays the **Abstract Syntax Tree** for all commands, showing the hierarchical structure and depth of each node.

#### 🌳 AST Example 1: Symmetry Operations
Polyline with symmetric coordinates (x-axis and origin):

![AST with symmetry](images/elabp1.png)

#### 🌳 AST Example 2: Variable Assignment
Assignment of polyline concatenation:

![AST concatenation](images/elabp2.png)

---
## 🎨 Design Choices

### Parser Implementation

| Choice | Rationale |
|--------|----------|
| **No semicolons** | Input is accepted using end-of-line delimiters, allowing multiple sequential commands |
| **Floating-point coordinates** | Points treated as real numbers (`float`) for better precision in geometric calculations |
| **Extended functionality** | Added `string eq string` comparison beyond base requirements |

### AST Implementation

| Choice | Rationale |
|--------|----------|
| **N-ary tree structure** | Flexible tree that accommodates infinite point sequences |
| **Unified grammar** | Same grammatical rules used across both parser versions |
| **Depth visualization** | Tree nodes display depth information for structural analysis |

---

## 👥 Authors

**Tommaso Vilotto** - VR471487  
**Alex Gaiga** - VR471343

📅 **Academic Year**: 2023-2024

---

## 📚 References

- **Course**: Compiler Lab (Laboratorio di Compilatori)
- **Institution**: University of Verona
- **Technologies**: Lex, Yacc/Bison, C

---

## 📄 License

> **📚 Academic Notice**: This project was developed for educational purposes as part of the Compiler Lab course at the University of Verona.

