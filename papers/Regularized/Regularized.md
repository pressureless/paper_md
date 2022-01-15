---
title: Regularized Kelvinlets: Sculpting Brushes based on Fundamental Solutions of Elasticity
date: \today
author:
- name: FERNANDO DE GOES
  affiliation: Pixar Animation Studios
- name: DOUG L. JAMES
  affiliation: Pixar Animation Studios, Stanford University
abstract: |
 We introduce a new technique for real-time physically based volume sculpting of virtual elastic materials. Our formulation is based on the elastic response to localized force distributions associated with common modeling primitives such as grab, scale, twist, and pinch. The resulting brush-like displacements correspond to the regularization of fundamental solutions of linear elasticity in infinite 2D and 3D media. These deformations thus provide the realism and plausibility of volumetric elasticity, and the inter- activity of closed-form analytical solutions. To finely control our elastic deformations, we also construct compound brushes with arbitrarily fast spatial decay. Furthermore, pointwise constraints can be imposed on the displacement field and its derivatives via a single linear solve. We demon- strate the versatility and efficiency of our method with multiple examples of volume sculpting and image editing.
---
❤: Regularized

# INTRODUCTION
Digital sculpting is a core component in modeling and animation packages, e.g., ZBrush, Scultpris, MudBox, Maya, or Modo. While purely geometric approaches are commonplace for shape editing, physically based deformers have long been sought to provide a more natural and effective sculpting tool for digital artists. However, existing physics-driven methods tend to have practical impediments for interactive design: they are inherently slow due to the need to numerically solve equations of the underlying discrete deformation model, and also involve tedious setup steps such as volumetric meshing, boundary condition specification, or preprocessing to accelerate the simulation.

In this paper, we introduce a novel sculpting tool that offers inter- active and physically plausible deformations. Our approach is based on the regularization of the fundamental solutions to the equations of linear elasticity for specific brush-like forces (e.g., grab, twist, pinch) applied to a virtual infinite elastic space. Since the fundametal solutions of linear elasticity for singular loads are known as Kelvin- lets [Phan-Thien and Kim 1994], we refer to our new solutions as regularized Kelvinlets. This formulation leads to analytical closed- form expressions, thus making our method free of any geometric discretization, computationally intensive solve, or large memory requirement. Instead, our brush-like deformations can be rapidly evaluated on the fly for sculpting sessions, with interactive con- trol of the volume compression of the elastic material (Figure 1). To address the typical long-range falloffs of the fundamental so- lutions, we present a multi-scale extrapolation scheme that builds compound brushes with arbitrarily fast decay, thereby enabling highly localized edits. For more specialized control, we also propose a linear combination of brushes that imposes pointwise constraints on displacements and gradients through a single linear solve. In summary, regularized Kelvinlets offer volume-aware deformations that are efficient to evaluate, easy to parallelize, and complementary to existing modeling techniques.

# RELATED WORK
Sculpting methods for digital shapes have been investigated exten- sively in graphics, see survey in [Cani and Angelidis 2006]. The most common sculpting tool is the family of grab/twist/scale/pinch brushes available in commercial modeling packages, e.g., [Autodesk 2016]. In these brushes, a single affine transformation is applied to every point in space and scaled by a predefined falloff. The simple setup and fast analytical evaluation make these tools suitable for highly detailed modeling, as well as animation and post-simulation edits. Motivated by these premises, our work augments existing brush deformations with interactive elastic response.

In order to provide volume-aware sculpts, Angelidis et al. [2004] introduced the notion of sweeper brushes, which deform the space with no self-intersection by advecting points along user-authored displacement fields. This technique was later extended to swirling- sweepers [Angelidis et al. 2006] that ensure constant-volume defor- mations by emulating the formation of vortex rings in incompress- ible fluids. Similarly, the work of von Funck et al. [2006] proposed deformations with divergence-free displacements generated by user- designed scalar fields. Our approach shares similar properties with sweeper brushes, in particular, it guarantees foldover-free sculpts guided by displacement fields. However, we model a wider family of brush deformations that incorporates volumetric responses to elastic materials with compression. Also, instead of crafting func- tions that produce incompressible flows, we design smooth force distributions and rely on analytical solutions to the equations of elasticity to produce physically based deformations.

Solid modeling and carving were also explored using voxel dis- cretizations [Galyean and Hughes 1991], sampled distance func- tions [Frisken et al. 2000], and adaptive resolution [Ferley et al. 2001]. In [Dewaele and Cani 2004], physics-aware volume sculpt- ing was addressed through voxel-based approximations of elastic and plastic deformations. However, these methods are restricted to grid-like data structures and tend to produce over-smoothed shapes. Other interactive techniques rely on user-controlled handles to drive volumetric deformations. This includes lattice deformers [Coquillart 1990; Sederberg and Parry 1986], cage-based generalized barycentric coordinates [Joshi et al. 2007; Lipman et al. 2008], linear blending skinning [Magnenat-Thalmann et al. 1988], wire curves [Singh and Fiume 1998], and sketch editing [Cordier et al. 2016], to cite a few. In [Jacobson et al. 2011], various handle types were supported by optimizing a unified linear blending scheme. In contrast to our work, these approaches require a careful placement of handles and a precomputation step that binds handles to the deforming objects. Moreover, the resulting deformations are purely geometric with limited volume control.

Aiming at physically plausible deformations, some methods com- bined handle-based systems with simulation techniques. For in- stance, Jacobson et al. [2012] posed skinned skeletons by minimizing an elastic potential energy, while Hahn et al. [2012] projected the equations of elasticity to the subspace spanned by animation rigs. In a similar way, the work of Ben-Chen et al. [2009] deformed a cage mesh by optimizing the rigidity of the associated deformation. In [Kavan and Sorkine 2012], an elasticity-inspired skinning was presented by constructing joint deformers. Physics-driven video editing was also considered by combining simulation with image aware constraints [Bazin et al. 2016]. It is also worth mentioning advances in elasticity solvers that speed up quasi-static simulations in 2D [Setaluri et al. 2014] and 3D [McAdams et al. 2011]. Model reduction can also make simulations orders of magnitude faster by precomputing deformation modes [Barbič and James 2005] and multi-domain subspaces [Barbič and Zhao 2011]. Surface-only meth- ods were also proposed to approximate elastic materials using, e.g., rigidity penalties [Sorkine and Alexa 2007] and moving frames [Lip- man et al. 2007]. Since these approaches rely on mesh discretizations and non-linear solvers, we consider them complementary to our mesh-free closed-form solutions.

Our work is closely related to the concept of regularized Stokeslets. Coined by Hancock [1953], Stokeslets are singular fundamental so- lutions of Stokes flows (i.e., incompressible fluid flows with low Reynolds number [Chwang and Wu 1975]) based on pointwise loads. To remove the singularity of these solutions, Cortez [2001] introduced regularized Stokeslets as an alternative that replaces impulses by smoothed force distributions. Extensions to doublets and the method of images were later derived in [Ainley et al. 2008; Cortez et al. 2005], and employed to model the trajectories of self- propelled micro-organisms. Instead, we introduce the regularization of the fundamental solutions of linear elasticity, thus generalizing regularized Stokeslets to arbitrary elastic materials. In particular, our formulation reproduces regularized Stokeslets in the case of incompressible elasticity. In addition, we present a new approach to design regularized solutions with faster decays.

Finally, we point out that fundamental solutions are central to integral formulations of elasticity and discretizations such as the boundary element method (BEM) [Brebbia et al. 2012]. In [James and Pai 1999], BEM was employed to deform surface meshes by approximating contact mechanics. However, this technique requires the precomputation and incremental updates of boundary condi- tions for displacements and surface tractions. This approach was later accelerated by compressing singular fundamental solutions of linear elasticity based on wavelets [James and Pai 2003]. In contrast, we advocate the use of regularized fundamental solutions for digital sculpting, with no boundary specification or mesh discretization.

# BACKGROUND

Before presenting our new sculpting tools, we first review core concepts of linear elastostatics upon which our formulation is based. In the next sections, we focus our exposition on 3D linear elasticity and postpone the 2D case to Section 8, where the analogous 2D expressions are derived using our 3D results. For more details on linear elastostatics, we point the reader to [Slaughter 2002].

Elastostatics: In an infinite 3D continuum, the quasi-static equi- librium state of linear elasticity is determined by a displacement field u : R3 → R3 that minimizes the elastic potential energy 

$$
E(\boldsymbol{u})=\frac{\mu}{2}\|\nabla \boldsymbol{u}\|^{2}+\frac{\mu}{2(1-2 v)}\|\nabla \cdot \boldsymbol{u}\|^{2}-\langle\boldsymbol{b}, \boldsymbol{u}\rangle
$$

where ∥ · ∥ and ⟨·, ·⟩ are integrated over the infinite elastic volume. The first term in (1) controls the smoothness of the displacement field, the second term penalizes infinitesimal volume change, and the last term indicates the external body forces b to be counteracted. In this formulation, linear homogeneous and isotropic material param- eters are given by the elastic shear modulus μ and the Poisson ratio ν. Note that, while the former is a simple scaling factor indicating the material stiffness, the latter dictates the material compressibil- ity. By computing the critical point of (1), one can associate the optimal displacement field u with the solution of the well-known Navier-Cauchy equation (see, e.g., [Slaughter 2002]):

$$
\mu \Delta \boldsymbol{u}+\frac{\mu}{(1-2 v)} \nabla(\nabla \cdot \boldsymbol{u})+\boldsymbol{b}=0
$$

Kelvinlets: In the case of a concentrated body load due to a force vector f at a point x0, i.e., b(x) = f δ(x −x0), the solution of (2) defines the (singular) fundamental solution of linear elasticity, also known as the Kelvin’s state [Kelvin 1848] or Kelvinlet [Phan-Thien and Kim 1994], which can be written as

``` iheartla
placeholder = 1
``` 
where r =x−x0 is the relative position vector from the load location x0 to an observation point x, and r = ∥r ∥ is its norm. The coefficients in (3) are of the forma=1/(4πμ) andb=a/[4(1−ν)]. Here, we refer to K(r) as the Green’s function for linear elasticity that defines a 3×3 matrix mapping the force vector f at x0 to the displacement vector u at a relative position r . Notice that the first term in K(r ) resembles the Laplacian Green’s function scaled by a constant, while the second term controls volume compression by modifying the elastic response based on the alignment of the relative position vector r to the force vector f . Moreover, observe that no boundary conditions were needed for the definition of Kelvinlets, since these displacement fields are the minimizer of the elastic potential energy over the infinite space.

Stokeslets: An important special case of linear elastostatics occurs for incompressible materials, i.e., ν = 1/2. In this case, the divergence penalty term in (1) becomes a hard constraint ∇ · u = 0 that ensures incompressible displacements. The solution for this constrained minimization can be computed via the Stokes equation:


$$
\mu \Delta \boldsymbol{u}+\boldsymbol{b}-\nabla p=0 \quad \text { subject to } \quad \nabla \cdot \boldsymbol{u}=0
$$

where p is the pressure scalar field acting as a Lagrangian multiplier that enforces the divergence-free constraint. For a pointwise load with force vector f , the (singular) fundamental solution of (4) is known as the Stokeslet [Chwang and Wu 1975; Hancock 1953], and matches the expression in (3) with ν =1/2 (i.e., b =a/2).

Deformation Gradient: From a displacement field u(x −x0), an arbitrary point x embedded in a linear elastic material is deformed to x +u(x −x0). The associated deformation gradient is then defined bya3×3matrixoftheformG(x−x0)=I+∇u(x−x0). By analyzing this matrix G(r), we can obtain different properties of the displace- ment field u(r) (see, e.g., [Slaughter 2002]). For instance, the skew- symmetric part of ∇u(r) indicates the infinitesimal rotation induced by u(r), while its symmetric part corresponds to the elastic strain and determines the infinitesimal stretching. The strain tensor can be also decomposed into a trace term that represents the uniform scaling of the volume of the elastic medium, and a traceless term that informs the undergoing pinching deformation. We will use these deformation gradient decompositions in Section 6 to construct twist, scale, and pinch elastic brushes.

# 3D REGULARIZED KELVINLETS
The concentrated body load at a single point x0 introduces a singu- larity to the Kelvinlet solution, making its displacements and deriva- tives indefinite nearby x0. For this reason, the singular Kelvinlet is numerically unsuitable for digital sculpting. To overcome this issue, we adopt the regularization scheme introduced in [Cortez 2001], andconsiderasmoothedbodyloadb(r)=fρε(r)
μàu+ μ ∇(∇·u)+b=0. (1−2ν)
(2) Kelvinlets: In the case of a concentrated body load due to a force
with force vector f and normalized density
function ρε(r) distributed around x0 by a
radial scale ε > 0. Similar to [Cortez et al.
2005], we define the regularized distance √
rε = r2+ε2 and set the normalized density function to be of the form (see inset)

``` iheartla
`$row_ε$`(r) = (15`$r_ε$`/8 + 1/`$r_ε$`³ )  where r ∈ ℝ^3

```


# MULTI-SCALE EXTRAPOLATION

Sculpting brushes are commonly accompanied by falloff profiles that define the locality of the deformations. Generally, these func- tions are set independently of the brush operation and can even be adjusted by the user. In contrast, the spatial decay of regular- ized Kelvinlets is determined completely by the equations of linear elasticity. This fixed falloff may make our elastic deformations in- adequate for fine sculpts in which a faster decay is demanded. To address this issue, we present next an extrapolation scheme that constructs physically based brushes with arbitrarily fast decays by linearly combining regularized Kelvinlets of different radial scales. Due to the superposition principle, these compound brushes form high-order regularized Kelvinlets that satisfy (2).


``` iheartla
`$u_ε$`(r) = ((a-b)/`$r_ε$`I_3 + b/`$r_ε$`³ r r^T + a/2 ε²/`$r_ε$`³ I_3 ) f where r ∈ ℝ^3

where

f ∈ ℝ^3
``` 


# EXTENSION TO AFFINE LOADS
 
So far we showed how to use regularized Kelvinlets to construct grablike deformations guided by the brush tip displacement. However, other sculpting operations assign an affine transformation, instead of a translation, to the brush. A typical example is the twist brush which defines a rotation centered at x0. Similarly, scale and pinch brushes are generated based on affine transformations. In order to augment these brushes with elastic response, we propose to extend the formulation of regularized Kelvinlets by replacing the vector-based load distribution with a matrix-based distribution.

Our approach leverages the linearity of the elastostatics equation with respect to differentiation. More specifically, given a regular- ized Kelvinlet uε and its associated force vector f , we compute the directional derivative д·∇ of (2) along the vector д, yielding


$$
\begin{aligned}
0 &=\boldsymbol{g} \cdot \nabla\left[\mu \Delta \boldsymbol{u}_{\varepsilon}+\frac{\mu}{(1-2 v)} \nabla\left(\nabla \cdot \boldsymbol{u}_{\varepsilon}\right)+\boldsymbol{b}\right] \\
&=\mu \Delta\left(\boldsymbol{g} \cdot \nabla \boldsymbol{u}_{\varepsilon}\right)+\frac{\mu}{(1-2 v)} \nabla\left[\nabla \cdot\left(\boldsymbol{g} \cdot \nabla \boldsymbol{u}_{\varepsilon}\right)\right]+\boldsymbol{g} \cdot \nabla \boldsymbol{b} \\
&=\mu \Delta \widetilde{\boldsymbol{u}}_{\varepsilon}+\frac{\mu}{(1-2 v)} \nabla\left[\nabla \cdot \widetilde{\boldsymbol{u}}_{\varepsilon}\right]+\widetilde{\boldsymbol{b}} .
\end{aligned}
$$

This implies that we can define a new body load $\widetilde{\boldsymbol{b}}(\boldsymbol{r})=\boldsymbol{g} \cdot \nabla \boldsymbol{b}(\boldsymbol{r})$ ,and its associated elastic response corresponds to the displacement field
$\tilde{\boldsymbol{u}}_{\varepsilon}(\boldsymbol{r})=g \cdot \nabla u_{\varepsilon}(\boldsymbol{r})$

We now consider the nine possible deformations $\tilde{\boldsymbol{u}}_{\varepsilon}^{i j}$ generated by setting $\boldsymbol{f}=\boldsymbol{e}_{i}$ and $\boldsymbol{g}=\boldsymbol{e}_{j}$ for every pair (i, j), where the vectors $\left\{\boldsymbol{e}_{1}, \boldsymbol{e}_{2}, \boldsymbol{e}_{3}\right\}$ form an orthonormal bases spanning $\mathbb{R}^{3}$. Due to super-position, we can linearly combine $\tilde{\boldsymbol{u}}_{\varepsilon}^{i j}$ with scalar coefficients $F_{i j}$, and obtain a matrix-driven solution of (2) of the form

$$
\widetilde{\boldsymbol{u}}_{\varepsilon}(\boldsymbol{r})=\sum_{i j} F_{i j} \boldsymbol{e}_{j} \cdot \nabla\left(\mathcal{K}_{\varepsilon}(\boldsymbol{r}) \boldsymbol{e}_{\boldsymbol{i}}\right)=\nabla \mathcal{K}_{\varepsilon}(\boldsymbol{r}): \boldsymbol{F}
$$


where $\boldsymbol{F}=\left[F_{i j}\right]$ is a 3×3 force matrix, and the symbol : indicates the double contraction of F to the third-order tensor $\nabla \mathcal{K}_{\varepsilon}(\boldsymbol{r})$, thus returning a vector. Similarly, we can write the body load that generates the deformation $\tilde{\boldsymbol{u}}_{\varepsilon}$ as

$$
\widetilde{\boldsymbol{b}}(\boldsymbol{r})=\sum_{i j} F_{i j} \boldsymbol{e}_{i} \boldsymbol{e}_{j}^{t} \nabla \rho_{\varepsilon}(\boldsymbol{r})=\boldsymbol{F} \nabla \rho_{\varepsilon}(\boldsymbol{r})
$$

By computing the spatial derivatives of $\boldsymbol{u}_{\varepsilon}$, we obtain the displacement field $\tilde{\boldsymbol{u}}_{\varepsilon}(\boldsymbol{r})$ in terms of the force matrix F :

$$
\begin{aligned}
\widetilde{u}_{\varepsilon}(\boldsymbol{r}) &=-a\left(\frac{1}{r_{\varepsilon}^{3}}+\frac{3 \varepsilon^{2}}{2 r_{\varepsilon}^{5}}\right) \boldsymbol{F r} \\
&+b\left[\frac{1}{r_{\varepsilon}^{3}}\left(\boldsymbol{F}+\boldsymbol{F}^{t}+\operatorname{tr}(\boldsymbol{F}) \boldsymbol{I}\right)-\frac{3}{r_{\varepsilon}^{5}}\left(\boldsymbol{r}^{t} \boldsymbol{F r}\right) \boldsymbol{I}\right] \boldsymbol{r}
\end{aligned}
$$

Note that the first term in (14) corresponds to an affine transformation Fr with a radial falloff similar to existing affine brushes, while the second term includes a symmetric affine transformation and controls volume compression through the Poisson ratio ν that b depends on. Therefore, we name this matrix-based extension of the fundamental solution of linear elasticity as a locally affine regular- ized Kelvinlet. For conciseness, we denote this displacement field by $\widetilde{u}_{\varepsilon}(\boldsymbol{r}) \equiv \mathcal{A}_{\varepsilon}(\boldsymbol{r}) \overrightarrow{\boldsymbol{F}}$, where $\overrightarrow{\boldsymbol{F}} \in \mathbb{R}^{9}$ is a vectorized form of F and $\mathcal{A}(\boldsymbol{r})$ is the 3×9 matrix that maps $\overrightarrow{\boldsymbol{F}$ to a displacement at $\boldsymbol{r}$.


In contrast to (6), the deformation generated by (14) has zero displacement at the brush center, i.e., u􏰜ε (0) = 0, but a non-trivial gradient in terms of F (the closed-form expression is provided in the supplemental material). As the radial scale ε approaches zero, our matrix-based solutions reproduce the definition of Kelvinlet doublets [Phan-Thien and Kim 1994]. These expressions also coincide with the regularized Stokeslet doublets [Ainley et al. 2008] in the incompressible limit (ν = 1/2). Following the matrix decomposition in Section 3, we can further construct specialized versions of the locally affine regularized Kelvinlets by setting F to different types of matrices, as illustrated in Figure 5.

Twisting: In the case of a skew-symmetric matrix, we can associate F to a vector q via the cross product matrix, i.e., $F \equiv[q]_{\times}$ where $[\boldsymbol{q}]_{\times} \boldsymbol{r}=\boldsymbol{q} \times \boldsymbol{r}$, then (14) simplifies to a twist deformation

``` iheartla
`$t_ε$`(r) = -a(1/`$r_ε$`³ + 3ε²/(2`$r_ε$`⁵) ) q×r where r ∈ ℝ^3

where

q ∈ ℝ^3
``` 

By analyzing the deformation gradient of (15) (see supplemental material), one can verify that its symmetric part (the strain tensor) is trivial for any $\boldsymbol{r}$. Consequently, this displacement field has zero divergence (i.e., $\left.\nabla \cdot \boldsymbol{t}_{\varepsilon}(\boldsymbol{r})=0\right)$ ) and defines a volume preserving deformation, independent of the Poisson ratio ν. Instead, its curl is non-zero and can be used to relate the vector $\boldsymbol{q}$ to the vorticity $\bar{\omega}$ at $x_{0}$ via the linear constraint $\nabla \times t_{\varepsilon}(0)=\bar{\omega}$.

Scaling: Another type of locally affine regularized Kelvinlet can be generated by a force matrix of the form $F=s I$, where s is a scalar. In this case, (14) reduces to a scaling deformation
``` iheartla
`$s_ε$`(r) = (2b-a)(1/`$r_ε$`³ + 3ε²/(2`$r_ε$`⁵))(sr) where r ∈ ℝ^3

where

s ∈ ℝ
``` 

where positive values of s represent contractions, and negative values determine dilations. Notice that we have sε (r ) = 0 for incompressible elastic materials, since ν = 1/2 implies a = 2b .


Pinching: The last type of locally affine regularized Kelvinlet is constructed based on a symmetric force matrix F with zero trace (in a total of 5 DoFs), and it generates displacements of the form
``` iheartla
`$p_ε$`(r) = (2b-a)/`$r_ε$`³ Fr - 3/(2`$r_ε$`⁵)(2b(rᵀFr)I_3+aε²F)r where r ∈ ℝ^3

where

F ∈ ℝ^(3×3)
`$r_ε$` ∈ ℝ
a ∈ ℝ 
b ∈ ℝ
ε ∈ ℝ
``` 
To geometrically characterize this deformation, we computed the displacement gradient ∇pε at x0, and observed that the resulting matrix is also symmetric with zero trace. This indicates that the deformation generated by pε (r ) compensates infinitesimal stretch- ing in one direction by contractions in the other directions, thus resembling a physical pinching interaction.


Multi-scale extrapolation: Since our affine brushes are based on the derivative of (6), the extrapolation scheme described in Section 5 applies to these displacement fields with no modification. We can then combine locally affine regularized Kelvinlets linearly and gen- erate new matrix-driven solutions of linear elasticity with arbitrarily fast far-field decay. In particular, we obtain bi-scale and tri-scale brushes with O(1/r4) and O(1/r6) falloffs, respectively, while the single-scale case has an O(1/r2) decay.




