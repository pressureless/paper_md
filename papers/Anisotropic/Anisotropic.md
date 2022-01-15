---
full_paper: False
---
❤: Anisotropic
# The Eigensystem of $I_5$
 
We will now show that the eigensystem of any energy expressed solely in terms of $I_5$ can be written down in closed form. The $I_5$ invariant can be written in several forms,

``` iheartla
tr from linearalgebra
`$I_5$` = tr(CA)

where

a ∈ ℝ^3
C ∈ ℝ^(3×3)
```
where ❤ A = a a^T ❤ and $\|\cdot\|_{2}^{2}$ denotes the squared Euclidean norm. The PK1 and Hessian in 3D are

``` iheartla
`$\frac{∂²I₅}{∂f²}$` = 2[A₁,₁I₃  A₁,₂I₃  A₁,₃I₃
               A₂,₁I₃  A₂,₂I₃  A₂,₃I₃
               A₃,₁I₃  A₃,₂I₃  A₃,₃I₃] 


```
where $I _{3×3}$ is a 3×3 identity matrix,and $A _{ij}$ is the (i,j) scalar entry of $A$. (Appendix A shows the matrix explicitly.) Since Eqn. 7 is constant in a, it is straightforward to state its eigensystem in closed form. In 3D, it contains three identical non-zero eigenvalues, $\lambda_{0,1,2}=2\|\mathbf{a}\|_{2}^{2}$, and since fiber directions are usually normalized, this simplifies to $\lambda_{0,1,2}=2$. The eigenvalue is repeated, so the eigenmatrices are arbitrary up to rotation, but one convenient phrasing is:

$$
\mathbf{Q}_{0}=\left[\begin{array}{ccc} 
& \mathbf{a}^{T} & \\
0 & 0 & 0 \\
0 & 0 & 0
\end{array}\right] \quad \mathbf{Q}_{1}=\left[\begin{array}{ccc}
0 & 0 & 0 \\
& \mathbf{a}^{T} & \\
0 & 0 & 0
\end{array}\right] \quad \mathbf{Q}_{2}=\left[\begin{array}{ccc}
0 & 0 & 0 \\
0 & 0 & 0 \\
& \mathbf{a}^{T} &
\end{array}\right]
$$
 
This eigenstructure has a straightforward interpretation. $I_5$ introduces scaling constraints along the anisotropy direction, so the three eigenvectors encode this rank-three phenomenon. The remaining eigenvalues are all zero, so the Hessian contains a rank-six null space. We have provided supplemental Matlab/Octave code that validate these expressions.

The 2D case follows similarly. The Hessian is
$$
\frac{\partial^{2} I _{5}}{\partial \mathbf{f}^{2}}=2\left[\begin{array}{ll}
\mathbf{A}_{00} \mathbf{I}_{2 \times 2} & \mathbf{A}_{01} \mathbf{I}_{2 \times 2} \\
\mathbf{A}_{10} \mathbf{I}_{2 \times 2} & \mathbf{A}_{11} \mathbf{I}_{2 \times 2}
\end{array}\right]=2 \mathbf{H}_{5}
$$

the eigenvalues are $\lambda_{0,1}=2\|\mathbf{a}\|_{2}^{2}$ and the eigenmatrices become
$$
\mathbf{Q}_{0}=\left[\begin{array}{cc}
\mathbf{a}^{T} \\
0 & 0
\end{array}\right] \quad \mathbf{Q}_{1}=\left[\begin{array}{ll}
0 & 0 \\
\mathbf{a}^{T} &
\end{array}\right]
$$






