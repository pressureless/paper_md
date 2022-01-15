---
full_paper: False
---
❤: Generic
# OBJECTIVITY BY OPTIMAL REFERENCE FRAME
 
The main idea of our approach is to estimate an optimal reference frame locally for every point (x, t ): the local frame (Q, c) is chosen such that the transformed velocity field is as steady as possible in a neighborhoodof(x,t).WelocallyassumethatQandcarespatially- constant. Since we waive the spatial and temporal connection to neighboring points, all derivatives are solved for individually, including $\dot{Q}, \ddot{Q}, \dot{\mathbf{c}}, \ddot{\mathbf{c}}^{1}$ 1. For every point (x,t), we define a spatial neighbor- hood U around it to which we fit the reference frame transformation. To compute the optimal reference frame in U , we set Q = I, c = 02, and find the unknowns Q􏰙 , Q , c, c, which contain 6 scalars (angles and offsets) in 2D and 12 in 3D, that minimize

$$
\int_{U}\left\|\mathbf{v}_{t}^{*}\right\|^{2} d V \rightarrow \min
$$

With these locally optimal $\dot{Q}, \ddot{Q}, \dot{\mathbf{c}}, \ddot{\mathbf{c}}^{1}$, we obtain the new local optimal fields v, J, vt , a by applying Eqs. (4)–(7). With these, existing vortex measures can be made objective simply by replacing v, J, vt , a with v, J, vt , a, respectively. Note that although Eq. (13) is minimized for every point (x,t), in practice it is computed only at discrete grid points; usually the same grid on which v is given.

Minimizing Eq. (13) is not straightforward, since vt∗ is non-linear in Q􏰙 , Q􏰚 , c􏰙, c􏰚. However, vt∗ can be equivalently rephrased and thereby linearized by substitution. Instead of solving for Q􏰙 , Q􏰚 , c􏰙, c􏰚 directly3, we solve for a suitable combination of these unknowns, stored in u:

$$
\mathbf{v}_{t}^{*}=\mathbf{Q}\left(\mathbf{v}_{t}-\mathbf{M} \mathbf{u}\right)
$$

In 3D, M is a 3 × 12 matrix

$$
\mathbf{M}=(-\mathbf{J} \mathbf{X}+\mathbf{V}, \mathbf{J}, \mathbf{X}, \mathbf{I})
$$

with X = sk(x), V = sk(v), and u is a 12-vector


$$
\mathbf{u}=\left(\begin{array}{l}
\mathbf{u}_{1} \\
\mathbf{u}_{2} \\
\mathbf{u}_{3} \\
\mathbf{u}_{4}
\end{array}\right)=\left(\begin{array}{c}
a p\left(\mathbf{Q}^{\mathrm{T}} \dot{\mathbf{Q}}\right) \\
\mathbf{Q}^{\mathrm{T}} \dot{\mathbf{c}} \\
a p\left(\mathbf{Q}^{\mathrm{T}} \ddot{\mathbf{Q}}-\left(\mathbf{Q}^{\mathrm{T}} \dot{\mathbf{Q}}\right)^{2}\right) \\
-\left(\mathbf{Q}^{\mathrm{T}} \ddot{\mathbf{c}}-\mathbf{Q}^{\mathrm{T}} \dot{\mathbf{Q}} \mathbf{Q}^{\mathrm{T}} \dot{\mathbf{c}}\right)
\end{array}\right)
$$



In 2D, M and u have a slightly different form. M is a 2 × 6 matrix



``` iheartla
M=[-J`$x_p$`+`$v_p$`  J  `$x_p$`  I_2] 

where
J: ℝ^(2×2)
x: ℝ 
y: ℝ 
u: ℝ
v: ℝ  

```

with ❤ `$x_p$` = (-y, x)❤, ❤ `$v_p$` = (-v, u)❤, and u is a 6-vector. Note that u1 and u3 are scalars in 2D, namely the first-order and second- order derivative of the angular velocity of the rotation of the frame. The reformulation of Eq. (7) into Eq. (14)–(17) is a straightforward exercise in algebra. Eq. (14) shows that the vector field and the reference frame are completely separated: M contains only v and its derivatives, while all information of the frame is stored in u.


Eq. (13) is minimized using Eq. (14), which can be written as the solution of the linear system

$$
\begin{gathered}
\widehat{\mathbf{M}} \mathbf{u}=\widehat{\mathbf{y}} \\
\text { with } \widehat{\mathbf{M}}=\int_{U} \mathbf{M}^{\mathrm{T}} \mathbf{M} d V \quad, \quad \widehat{\mathbf{y}}=\int_{U} \mathbf{M}^{\mathrm{T}} \mathbf{v}_{t} d V .
\end{gathered}
$$


T −1
the new fields in the locally optimal reference frame are


$$
\begin{aligned}
\overline{\mathbf{v}} &=\mathbf{v}+s k\left(\overline{\mathbf{u}}_{1}\right) \mathbf{x}+\overline{\mathbf{u}}_{2} \\
\overline{\mathbf{J}} &=\mathbf{J}+s k\left(\overline{\mathbf{u}}_{1}\right) \\
\overline{\mathbf{v}}_{t} &=\mathbf{v}_{t}-\mathbf{M} \overline{\mathbf{u}} \\
\overline{\mathbf{a}} &=\overline{\mathbf{J}} \overline{\mathbf{v}}+\overline{\mathbf{v}}_{t}
\end{aligned}
$$




whichfollowsdirectlyfrominsertionofu ,u ,u ,u intotheEqs.(4)–
1234 (7), using the operator sk from Eq. (1) to remove ap.




Theorem 4.1 (Objectivity in Optimal Frames). Given an at least C1 continuous vector field v, let v be its observation in the most- steady reference frame and let J, vt , a be its observed derivatives. Any scalar measure s that is computed from v, J, a, vt remains unchanged under any smooth rotation and translation of the reference frame of v as in Eq. (3). A vector r that is computed in the optimal frame from v, J, a, vt is objective, i.e., a transformation of v via Eq. (3) transforms r to r∗ = Q(t ) r. A second-order tensor T computed from v, J, a, vt is objective, since a transformation of v via Eq. (3) transforms T to T∗ =Q(t)TQ(t)T.



See Appendix B for a proof that v, J, vt , a are objective. Theorem 4.2 (Continuity of Solution). If the input vector field
visC1continuous,thenv,J,a,v areatleastC0continuous. t
All v, J, a, vt are computed by integrating only first-order deriva- tives in a region U . If both v and its first-order partials are continuous (i.e., v is C1 continuous), then v is at least C0 continuous.


















