# DESIGN OBJECTIVES
Our optimization-driven pattern design framework is completed by a set of design objectives that can be combined according to the requirements of a given application. We first introduce the individual objectives, then provide examples in Sec. 6.

## Shape Objective
Within the limits set by physics and comfort, skintight clothing often provides room for shaping the underlying body. Our coupled model allows us to exploit this ability in our automated pattern design framework. For this purpose, we introduce a shape objec- tive that measures the distance between the current deformed cloth and a given target shape. For better shape approximation, we avoid restrictive per-vertex correspondence and instead use a distance- field approach based on implicit moving least squares (IMLS) sur- faces [Öztireli et al. 2009]. The corresponding objective is defined as

``` iheartla(first)
P = sum_i sum_k ((sum_k )/φ(x_k - c_k))^2
where
x_i ∈ ℝ^3
c_k ∈ ℝ
```
where ck are the vertices of the target shape and φ is a locally supported kernel function,
``` iheartla(first)
φ(r) = (1-r^2/h^2)^4 where r ∈ 
where 
h ∈ ℝ
```
that vanishes beyond the cut-off distance h.




