function output = elastic(E_r, q_g, q_h, m_g, m_h, angle, lambda_q_1, lambda_q_2, t, lambda_a_1, lambda_a_2, q, q_a, m, m_a, delta_minus_sign, delta_plus_sign, beta_q, beta_minus_sign, beta_plus_sign, mu, epsilon)
% output = elastic(`$E_r$`, `$q_g$`, `$q_h$`, `$m_g$`, `$m_h$`, `$\angle$`, `$λ_{q,1}$`, `$λ_{q,2}$`, t, `$λ_{a,1}$`, `$λ_{a,2}$`, q, `$q_a$`, m, `$m_a$`, `$δ^{(−)}$`, `$δ^{(+)}$`, `$β_q$`, `$β^{(−)}$`, `$β^{(+)}$`, μ, ε)
%
%    E = `$E_r$` + `$E_q$` + `$E_a$` + `$E_n$` + `$E_p$`
%    where
%    `$E_r$` ∈ ℝ
%    
%    `$E_q$` = `$λ_{q,1}$`||`$q_g$`-`$q_h$`+t`$m_g$`||^2 + `$λ_{q,1}$`||`$q_h$`-`$q_g$`+t`$m_h$`||^2 + `$λ_{q,2}$`||`$\angle$`(`$m_g$`,`$m_h$`)||^2 
%    where
%    `$q_g$` ∈ ℝ^n
%    `$q_h$` ∈ ℝ^n
%    `$m_g$` ∈ ℝ^n 
%    `$m_h$` ∈ ℝ^n 
%    `$\angle$` ∈ ℝ^n, ℝ^n -> ℝ^n
%    `$λ_{q,1}$` ∈ ℝ
%    `$λ_{q,2}$` ∈ ℝ
%    t ∈ ℝ
%    
%    `$E_a$` = `$λ_{a,1}$`||q-`$q_a$`||^2 + `$λ_{a,2}$`||`$\angle$`(m,`$m_a$`)||^2 
%    where
%    `$λ_{a,1}$` ∈ ℝ
%    `$λ_{a,2}$` ∈ ℝ
%    q ∈ ℝ^n 
%    `$q_a$` ∈ ℝ^n 
%    m ∈ ℝ^n 
%    `$m_a$` ∈ ℝ^n 
%    
%    `$E_n$` = `$δ^{(−)}$`(1/10 log((`$β_q$`-`$β^{(−)}$`)))^2 + `$δ^{(+)}$`(1/10 log((`$β^{(+)}$`-`$β_q$`)))^2
%    where
%    `$δ^{(−)}$` ∈ ℝ
%    `$δ^{(+)}$` ∈ ℝ
%    `$β_q$` ∈ ℝ
%    `$β^{(−)}$` ∈ ℝ
%    `$β^{(+)}$` ∈ ℝ
%    
%    `$E_p$` = (μ log((ε + `$β_q$`)))^2 + (μ log((ε + 1 - `$β_q$`)))^2
%    where
%    μ ∈ ℝ
%    ε ∈ ℝ
%    
    if nargin==0
        warning('generating random input data');
        [E_r, q_g, q_h, m_g, m_h, angle, lambda_q_1, lambda_q_2, t, lambda_a_1, lambda_a_2, q, q_a, m, m_a, delta_minus_sign, delta_plus_sign, beta_q, beta_minus_sign, beta_plus_sign, mu, epsilon] = generateRandomData();
    end
    function [E_r, q_g, q_h, m_g, m_h, angle, lambda_q_1, lambda_q_2, t, lambda_a_1, lambda_a_2, q, q_a, m, m_a, delta_minus_sign, delta_plus_sign, beta_q, beta_minus_sign, beta_plus_sign, mu, epsilon] = generateRandomData()
        E_r = randn();
        lambda_q_1 = randn();
        lambda_q_2 = randn();
        t = randn();
        lambda_a_1 = randn();
        lambda_a_2 = randn();
        delta_minus_sign = randn();
        delta_plus_sign = randn();
        beta_q = randn();
        beta_minus_sign = randn();
        beta_plus_sign = randn();
        mu = randn();
        epsilon = randn();
        n = randi(10);
        q_g = randn(n,1);
        q_h = randn(n,1);
        m_g = randn(n,1);
        m_h = randn(n,1);
        angle = @angleFunc;
        rseed = randi(2^32);
        function tmp =  angleFunc(p0, p1)
            rng(rseed);
            tmp = randn(n,1);
        end

        q = randn(n,1);
        q_a = randn(n,1);
        m = randn(n,1);
        m_a = randn(n,1);
    end

    q_g = reshape(q_g,[],1);
    q_h = reshape(q_h,[],1);
    m_g = reshape(m_g,[],1);
    m_h = reshape(m_h,[],1);
    q = reshape(q,[],1);
    q_a = reshape(q_a,[],1);
    m = reshape(m,[],1);
    m_a = reshape(m_a,[],1);

    n = size(q_g, 1);
    assert(numel(E_r) == 1);
    assert( numel(q_g) == n );
    assert( numel(q_h) == n );
    assert( numel(m_g) == n );
    assert( numel(m_h) == n );
    assert(numel(lambda_q_1) == 1);
    assert(numel(lambda_q_2) == 1);
    assert(numel(t) == 1);
    assert(numel(lambda_a_1) == 1);
    assert(numel(lambda_a_2) == 1);
    assert( numel(q) == n );
    assert( numel(q_a) == n );
    assert( numel(m) == n );
    assert( numel(m_a) == n );
    assert(numel(delta_minus_sign) == 1);
    assert(numel(delta_plus_sign) == 1);
    assert(numel(beta_q) == 1);
    assert(numel(beta_minus_sign) == 1);
    assert(numel(beta_plus_sign) == 1);
    assert(numel(mu) == 1);
    assert(numel(epsilon) == 1);

    % `$E_q$` = `$λ_{q,1}$`||`$q_g$`-`$q_h$`+t`$m_g$`||^2 + `$λ_{q,1}$`||`$q_h$`-`$q_g$`+t`$m_h$`||^2 + `$λ_{q,2}$`||`$\angle$`(`$m_g$`,`$m_h$`)||^2 
    E_q = lambda_q_1 * norm(q_g - q_h + t * m_g, 2).^2 + lambda_q_1 * norm(q_h - q_g + t * m_h, 2).^2 + lambda_q_2 * norm(angle(m_g, m_h), 2).^2;
    % `$E_a$` = `$λ_{a,1}$`||q-`$q_a$`||^2 + `$λ_{a,2}$`||`$\angle$`(m,`$m_a$`)||^2 
    E_a = lambda_a_1 * norm(q - q_a, 2).^2 + lambda_a_2 * norm(angle(m, m_a), 2).^2;
    % `$E_n$` = `$δ^{(−)}$`(1/10 log((`$β_q$`-`$β^{(−)}$`)))^2 + `$δ^{(+)}$`(1/10 log((`$β^{(+)}$`-`$β_q$`)))^2
    E_n = delta_minus_sign * (1 / 10 * log((beta_q - beta_minus_sign))).^2 + delta_plus_sign * (1 / 10 * log((beta_plus_sign - beta_q))).^2;
    % `$E_p$` = (μ log((ε + `$β_q$`)))^2 + (μ log((ε + 1 - `$β_q$`)))^2
    E_p = (mu * log((epsilon + beta_q))).^2 + (mu * log((epsilon + 1 - beta_q))).^2;
    % E = `$E_r$` + `$E_q$` + `$E_a$` + `$E_n$` + `$E_p$`
    E = E_r + E_q + E_a + E_n + E_p;
    output.E = E;
    output.E_q = E_q;
    output.E_a = E_a;
    output.E_n = E_n;
    output.E_p = E_p;
end

