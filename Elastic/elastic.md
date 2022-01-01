# PHYSICAL SIMULATION
To simulate the physical behavior of the deployed grid, we use a simulation based on discrete elastic rods [Bergou et al. 2010] and build upon the solution of [Vekhter et al. 2019]. We refer the reader to those papers for the details. Note, that the associated material frames of the rods do not need to be isotropic, which allows us also to model the exact cross sections of lamellas with a ratio of 1 : 10.

A central aspect of the kinematics of elastic geodesic grids is the ability of grid members to slide at connections, denoted in the following as q. In general, they do not coincide with the vertices of the discretized grid members. To handle them, we introduce barycentric coordinates βq to describe the location of a connection on a rod-edge. We also take the physical thickness t of the lamellas into account, which is modeled by an offset between the members д and h at each connection. Hence, a connection q consists of two points qд and qh with an offset t. Apart from sliding, members are allowed to rotate around connections about an axis that is parallel to the cross product of the edges qд and qh lie on.

Simulation. Our aim is to find the equilibrium state of the given elastic grid, which corresponds to an optimization problem of mini- mizing the energy functional

``` iheartla(first)
E = `$E_r$` + `$E_q$` + `$E_a$` + `$E_n$` + `$E_p$`
where
`$E_r$` ∈ ℝ
```
where Er is the internal energy of the rods, Eq is the energy of the connection constraints, Ea is the energy of the anchor constraints, En is the energy of the notch-limit constraints, and Ep is an addi- tional notch penalty term that also serves to account for friction. We perform the simulation by minimizing the entire energy E for the rod centerline points x using a Gauss-Newton method in a simi- lar fashion as proposed by Vekhter et al. [2019]. In Section 6.2 we perform an empirical evaluation of the accuracy of the simulation by comparing it to laser-scans of the makes.

For the sake of readability, we will define the constraint energy terms only for a single constraint each. Er is the sum of stretching, bending and twisting energies of each individual rod. As a full explanation of the DER formulation is out of scope for this paper, we refer the reader to the work of [Bergou et al. 2010] for a detailed description of these terms.

The connection constraint energy Eq is given by
``` iheartla(first)
`$E_q$` = `$λ_{q,1}$`||`$q_g$`-`$q_h$`+t`$m_g$`||^2 + `$λ_{q,1}$`||`$q_h$`-`$q_g$`+t`$m_h$`||^2 + `$λ_{q,2}$`||`$\angle$`(`$m_g$`,`$m_h$`)||^2 
where
`$q_g$` ∈ ℝ^n
`$q_h$` ∈ ℝ^n
`$m_g$` ∈ ℝ^n 
`$m_h$` ∈ ℝ^n 
`$\angle$` ∈ ℝ^n, ℝ^n -> ℝ^n
`$λ_{q,1}$` ∈ ℝ
`$λ_{q,2}$` ∈ ℝ
t ∈ ℝ
```
with mд and mh denoting the material vectors of д and h at q respec- tively. The term tm accounts for the thickness of the rods, while λq, 1 and λq,2 are the constraint weights for the position and direction terms.

The anchor constraint energy Ea ensures that both the position q and material vector m of the given connection do not deviate from the position qa and material vector ma of the corresponding anchor. It is given by

``` iheartla(first)
`$E_a$` = `$λ_{a,1}$`||q-`$q_a$`||^2 + `$λ_{a,2}$`||`$\angle$`(m,`$m_a$`)||^2 
where
`$λ_{a,1}$` ∈ ℝ
`$λ_{a,2}$` ∈ ℝ
q ∈ ℝ^n 
`$q_a$` ∈ ℝ^n 
m ∈ ℝ^n 
`$m_a$` ∈ ℝ^n 
```

with λa,1 and λa,2 as weights. This constraint applies to the grid corners and anchors.


The notch-limit constraint energy En ensures that the connection point remains within the bounds of the notch. They are specified by the notch length l and the sliding direction (cf. Section 4.5):

``` iheartla(first)
`$E_n$` = `$δ^{(−)}$`(1/10 log((`$β_q$`-`$β^{(−)}$`)))^2 + `$δ^{(+)}$`(1/10 log((`$β^{(+)}$`-`$β_q$`)))^2
where
`$δ^{(−)}$` ∈ ℝ
`$δ^{(+)}$` ∈ ℝ
`$β_q$` ∈ ℝ
`$β^{(−)}$` ∈ ℝ
`$β^{(+)}$` ∈ ℝ
```


with β (−) and β (+) denoting the barycentric coordinates of the notch bounds on their corresponding edges. The term is only active when the connection lies on the same rod-edge as one of the notch bounds, so δ(−) = 1 or δ(+) = 1 when the connection lies on one of these edges, and 0 otherwise.

The additional notch penalty term Ep controls the movement of a connection q between two adjacent edges. If q switches edges, it needs to be reprojected to the neighboring edge at the next iteration of the simulation. Within an iteration, Ep prevents q from moving too far beyond the end of the current edge:

``` iheartla(first)
`$E_p$` = (μ log((ε + `$β_q$`)))^2 + (μ log((ε + 1 - `$β_q$`)))^2
where
μ ∈ ℝ
ε ∈ ℝ
```
with ε denoting how far q is allowed to move past the end of the edge and μ acting as a weighting parameter (we choose ε = 0.0001, μ = 0.1).

Since Ep is not 0 even inside the edge, it penalizes very small sliding movements that would otherwise accumulate over many it- erations. In other words, Ep creates a pseudo-frictional effect, which is controlled by μ. In a physical grid, friction creates a force acting against the sliding movement of a connection. If the driving force of the movement and the frictional force counterbalance, the move- ment stops. This situation has an analogy in our grids. A connection stops moving inside a notch if

$$\frac{\partial E_q}{\partial β_q} + \frac{\partial E_p}{\partial β_q} = 0 $$

is fulfilled. Figure 11 depicts the effects of different values for μ.








