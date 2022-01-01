# Model reduction and subspace splitting

Next, we define the splitting G and H, crucial to the success of our method. The idea is to apply ERE in the subspace of the first s modes (s ≪ n: typically, 5 ≤ s ≤ 20) and project it back to the original full space. In the bridge example of Figure 1, n ≈ 100, 000, so this is a rather large reduction.

Then we use SI on the remaining unevaluated part, as per Eq. (5).
We use mass-PCA to find our reduced space. That is, considering at
the beginning of each time step a solution mode of the form q(t) = √
wexp(ı λt)fortheODEMq􏰊+Kq=0,wesolvethegeneralized eigenvalue problem

$$ Kw = λMw $$

for the s smallest eigenvalues λ and their corresponding eigen- vectors w (dominant modes). In Matlab, for instance, this can be achieved by calling the function eigs. In our implementation, we use the C++ Spectra library [Qiu 2019]. Denote this partial spectral decomposition by

$$KUs =MUsΛs$$
where the “long and skinny” Us is n × s, has the first s eigenvectors w as its columns, and the small Λs is a diagonal s × s matrix with the eigenvalues λ1, ..., λs on the diagonal. Notice that both K and M are large sparse symmetric matrices. In addition, M is positive definite, so Us has M-orthogonal columns:

$$UsTMUs =Is, UsTKUs =Λs. $$

Next, we write Eq. (2) in the split form Eq. (3), with the splitting H and G defined based on the partial spectral decomposition Eq. (6). We define at each time step


$$sadf$$


We also need the Jacobian matrices



$$aaa$$

Notice that the ERE expression, hφ1(hJG )G(u), can be evaluated in the subspace first, and then projected back to the original space.

The additive method defined by inserting Eqs. (8) and (9) into Eq.(5) has three advantages:

- (1) At each time step, the majority of the update comes from ERE
in the dominating modes. Thus it is less affected by artificial
damping from SI.
- (2) The computation load of ERE is greatly reduced, because the
stiff part is handled by SI (or BE for that matter). Furthermore, the evaluation of the exponential function in the subspace has only marginal cost since the crucial matrix involved has been diagonalized.
- (3) The “warm start” for SI makes its result closer to that of BE.


ERE update in the subspace: To evaluate the update in the subspace of dimension s we rewrite Eq. (5) as

$$asdf$$

where

$$aaaaaaa$$

The evaluation of the action of the matrix function φ1 involves only matrices of size 2s × 2s. Furthermore, the matrix function φ1 can be evaluated directly through the eigenpairs of JGr

$$sss$$

with el being the l t h column of the identity matrix.

The large n ×n linear system solved in Eq. (10) is not sparse due to the fill-in introduced by the small subspace projection. Specifically, the off-diagonal blocks of the Jacobian matrix JG defined in Eq. (9a) are not sparse. If not treated carefully, solving the linear system in Eq. (5) and Eq. (10) can be prohibitively costly. Fortunately, this
modification matrix has the low rank s. We can write

$$JG =Y1Z1T +Y2Z2T$$

where

Y1 = 0 , Z1 = MUs ,
2 −UsUsTKUs 2 0

The linear system in Eq. (10) becomes
$$ I−hJH =(I−hJ)+hY1Z1T +hY2Z2T $$

where the four matrices Yi and Zi are all “long and skinny” like Us , while the matrix J is square and large, but very sparse. Figure 3 illustrates this situation. For the linear system to be solved in Eq. (10) we may employ an iterative method such as conjugate gradient, whereby the matrix-vector products involving J or YiZiT are all straightforward to carry out efficiently. However, we have often found out that a direct solution method is more appropriate for these linear equations in our context. In our implementation we use pardiso [De Coninck et al. 2016; Kourounis et al. 2018; Verbosio et al. 2017]. For this we can employ the formula of Sherman, Morrison and Woodbury (SMW) [Nocedal and Wright 2006], given by

$$ (A+YZT)−1 =A−1 −A−1Y(I +ZTA−1Y)−1ZTA−1 $$

to solve the linear system in Eq. (10). In our specific notation we set at each time step A = I − h JH in Eq. (14), and apply the formula twice:onceforY = Y1, Z = Z1,andonceforY = Y2, Z = Z2. Note that the matrices I + ZT A−1Y in Eq. (14) are only 2s × 2s, and this results in an efficient implementation, so long as the subspace dimension s remains small.















