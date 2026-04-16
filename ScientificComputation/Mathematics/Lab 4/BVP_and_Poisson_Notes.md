# Numerical Notes: BVP and Poisson Problems

## Problem 1: 1D Boundary Value Problem

### Statement
Solve

\[
(x^3+1)\,y''(x) + (x^2-4x)\,y(x) = 2, \quad x\in(0,1),
\]
with boundary conditions

\[
y(0)=0,\quad y(1)=4.
\]

In the MATLAB code, this is solved for step sizes:

\[
h\in\{0.1,\,0.2,\,0.5\}.
\]

### Finite-Difference Idea
Use grid points:

\[
x_i = ih, \quad i=0,1,\dots,N, \quad Nh=1.
\]

Only interior unknowns \(y_1,\dots,y_{N-1}\) are solved. The boundary values \(y_0=0\), \(y_N=4\) are known.

Define:

\[
a(x)=x^3+1,\qquad c(x)=x^2-4x.
\]

A conservative second-derivative discretization gives a tridiagonal system:

\[
-\frac{a_{i-1/2}}{h^2}y_{i-1}
+\left(\frac{a_{i-1/2}+a_{i+1/2}}{h^2}+c_i\right)y_i
-\frac{a_{i+1/2}}{h^2}y_{i+1} = 2,
\]
where

\[
a_{i\pm1/2}\approx \frac{a(x_i)+a(x_{i\pm1})}{2},\quad c_i=c(x_i).
\]

Boundary values are moved into the RHS in the first and last interior equations.

### What the MATLAB script does
- Builds the grid for each \(h\).
- Constructs matrix \(A\) and RHS \(b\).
- Solves \(A\,y_{\text{in}}=b\).
- Reconstructs full \(y=[y_0;\,y_{\text{in}};\,y_N]\).
- Computes/interpolates \(y_h(0.5)\).
- Writes values to `diff_problem3.txt`.
- Opens interactive MATLAB figures:
- tiled plots (one for each \(h\))
- one comparison plot with all \(h\) curves

---

## Problem 2: 2D Poisson Equation

### Statement
Solve

\[
\nabla^2 u = 81xy,\quad (x,y)\in(0,1)\times(0,1),
\]
with Dirichlet boundary condition

\[
u=1 \text{ on the entire boundary.}
\]

### 5-Point Finite-Difference Method
On a uniform mesh \(x_i=ih\), \(y_j=jh\):

\[
\frac{u_{i-1,j}-2u_{i,j}+u_{i+1,j}}{h^2}
+
\frac{u_{i,j-1}-2u_{i,j}+u_{i,j+1}}{h^2}
=81x_i y_j.
\]

Rearranged interior equation:

\[
4u_{i,j}-u_{i-1,j}-u_{i+1,j}-u_{i,j-1}-u_{i,j+1}
=-h^2(81x_i y_j).
\]

This forms a sparse linear system \(A u_{\text{int}}=b\).

### What the MATLAB script does
- Sets `h = 0.1` (editable).
- Builds sparse matrix `A` with 5-point stencil.
- Adds boundary contributions (all equal to 1) into `b`.
- Solves for interior values, reconstructs full grid solution `U`.
- Writes a small summary (`h`, and value near center) to `poisson_q2_results.txt`.
- Opens interactive MATLAB plots:
- 3D surface (`surf`) with rotate and zoom enabled
- filled contour (`contourf`) with zoom enabled

---

## How to run
From MATLAB in the same folder:

```matlab
run('solve_bvp3.m')
run('solve_poisson_q2.m')
```

This will generate text result files and open interactive figure windows.
