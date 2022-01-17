---
full_paper: False
---
❤: Stable
# First Piola-Kirchhoff Stress (PK1)
 
We sart from the PK1 for Eqn. 14,

 

``` iheartla
`$P(F)$` = μ(1-1/(`$I_C$`+1))F + λ(J- α)`$\frac{\partial J}{\partial F}$`

where 
F: ℝ^(3×3)
μ: ℝ 
`$I_C$`: ℝ 
λ: ℝ  
```

where ❤α = 1 + μ/λ - μ/(4λ)❤. We omit the subscript, as we only consider one model in this section. Using the column-wise notation for F (Eqn.1) and the identity ❤J =`$f_0$`⋅(`$f_1$`×`$f_2$`)❤, we write $\frac{\partial J}{\partial F}$ (a.k.a.the cofactor matrix) as cross products:




``` iheartla
`$\frac{\partial J}{\partial F}$` = [`$f_1$`×`$f_2$` `$f_2$`×`$f_0$` `$f_0$`×`$f_1$`]

where 
`$f_0$`: ℝ^3 
`$f_1$`: ℝ^3 
`$f_2$`: ℝ^3 

```

This is a convenient shorthand for computing $\frac{\partial J}{\partial F}$, and will be useful when analyzing $\frac{\partial^2 J}{\partial F^2}$.








