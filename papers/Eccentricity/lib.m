function output = eccentricity(m, italic_p, italic_f_italic_s_0, a)
% output = eccentricity(m, đ, `$đ_{đ â}$`, a)
%
%     đ(đż) = Ďđ(đż)^2/4 â đż where đż : â
%    `$đ_0$` = 1488
%    q = (5.71 â 10^(-6), -1.78 â 10^(-4), 0.204)
%    cos, sin from trigonometry
%    
%    đ(x,`$x_0$`, đ,đ,`$đ_đ $`) = exp(-||x-`$x_0$`||^2/(2đ^2)) cos(2Ď`$đ_đ $`x â(cos(đ),sin(đ))) where x: â^2,`$x_0$`: â^2,`$đ_đ $`: â, đ : â, đ : â
%    
%    Î¨(đ, `$đ_đ $`)= m(0, đâ đ(`$đ_đ $`)^2 +đâ đ(`$đ_đ $`)+đâ + (đâ đ(`$đ_đ $`)^2 + đâ đ(`$đ_đ $`) +đâ)â đ(`$đ_đ $`)đ + (đâ đ(`$đ_đ $`)^2 +đâ đ(`$đ_đ $`) + đâ)âđ(`$đ_đ $`)đ^2) where `$đ_đ $` : â, đ: â
%    
%    đ(`$đ_đ $`) = exp(đââ đ(`$đ_đ $`)) - 1 where `$đ_đ $` : â
%    đ(`$đ_đ $`) = m(log_10(`$đ_đ $`)-log_10(`$đ_{đ â}$`), 0) where `$đ_đ $` : â
%    where
%    m: â, â -> â
%    đ: â^10: the model parameters
%    `$đ_{đ â}$`: â
%    
%    đ´(đ)= ln(64) 2.3/(0.106â(đ+2.3) )  where đ : â
%    
%    
%    đ(đż)= 7.75-5.75((đża/846)^0.41/((đża/846)^0.41 + 2))  where đż : â
%    where 
%    a : â
%    
%    
%     `$\hat{Î¨}$`(đ, `$đ_đ $`, đż) = (đ (đ, `$đ_đ $`) â (log_10(đ(đż)/`$đ_0$`)) + 1) Î¨(đ, `$đ_đ $`) where `$đ_đ $` : â, đ: â, đż : â
%    
%    
%    đ (đ,`$đ_đ $`) = đ(`$đ_đ $`)(q_1 đ^2 + q_2 đ) + q_3  where `$đ_đ $` : â, đ: â
%    
    if nargin==0
        warning('generating random input data');
        [m, italic_p, italic_f_italic_s_0, a] = generateRandomData();
    end
    function [m, italic_p, italic_f_italic_s_0, a] = generateRandomData()
        italic_f_italic_s_0 = randn();
        a = randn();
        m = @mFunc;
        rseed = randi(2^32);
        function [ret] =  mFunc(p0, p1)
            rng(rseed);
            ret = randn();
        end

        italic_p = randn(10,1);
    end

    italic_p = reshape(italic_p,[],1);

    assert( numel(italic_p) == 10 );
    assert(numel(italic_f_italic_s_0) == 1);
    assert(numel(a) == 1);

    % `$đ_0$` = 1488
    italic_l_0 = 1488;
    % q = (5.71 â 10^(-6), -1.78 â 10^(-4), 0.204)
    q = [5.71 * 10.^(-6); -1.78 * 10.^(-4); 0.204];
    function [ret_1] = italic_g(x, x_0, italic_theta, italic_sigma, italic_f_italic_s)
        x = reshape(x,[],1);
        x_0 = reshape(x_0,[],1);
        assert( numel(x) == 2 );
        assert( numel(x_0) == 2 );
        assert(numel(italic_theta) == 1);
        assert(numel(italic_sigma) == 1);
        assert(numel(italic_f_italic_s) == 1);

        ret_1 = exp(-norm(x - x_0, 2).^2 / (2 * italic_sigma.^2)) * cos(dot(2 * pi * italic_f_italic_s * x,[cos(italic_theta); sin(italic_theta)]));
    end

    function [ret_2] = italic_tau(italic_f_italic_s)
        assert(numel(italic_f_italic_s) == 1);

        ret_2 = m(log10(italic_f_italic_s) - log10(italic_f_italic_s_0), 0);
    end

    function [ret_3] = italic_zeta(italic_f_italic_s)
        assert(numel(italic_f_italic_s) == 1);

        ret_3 = exp(italic_p(10) * italic_tau(italic_f_italic_s)) - 1;
    end

    function [ret_4] = Psi(italic_e, italic_f_italic_s)
        assert(numel(italic_e) == 1);
        assert(numel(italic_f_italic_s) == 1);

        ret_4 = m(0, italic_p(1) * italic_tau(italic_f_italic_s).^2 + italic_p(2) * italic_tau(italic_f_italic_s) + italic_p(3) + (italic_p(4) * italic_tau(italic_f_italic_s).^2 + italic_p(5) * italic_tau(italic_f_italic_s) + italic_p(6)) * italic_zeta(italic_f_italic_s) * italic_e + (italic_p(7) * italic_tau(italic_f_italic_s).^2 + italic_p(8) * italic_tau(italic_f_italic_s) + italic_p(9)) * italic_zeta(italic_f_italic_s) * italic_e.^2);
    end

    function [ret_5] = italic_A(italic_e)
        assert(numel(italic_e) == 1);

        ret_5 = log(64) * 2.3 / (0.106 * (italic_e + 2.3));
    end

    function [ret_6] = italic_d(italic_L)
        assert(numel(italic_L) == 1);

        ret_6 = 7.75 - 5.75 * ((italic_L * a / 846).^0.41 / ((italic_L * a / 846).^0.41 + 2));
    end

    function [ret_7] = italic_l(italic_L)
        assert(numel(italic_L) == 1);

        ret_7 = pi * italic_d(italic_L).^2 / 4 * italic_L;
    end

    function [ret_8] = italic_s(italic_e, italic_f_italic_s)
        assert(numel(italic_e) == 1);
        assert(numel(italic_f_italic_s) == 1);

        ret_8 = italic_zeta(italic_f_italic_s) * (q(1) * italic_e.^2 + q(2) * italic_e) + q(3);
    end

    function [ret_9] = hatPsi(italic_e, italic_f_italic_s, italic_L)
        assert(numel(italic_e) == 1);
        assert(numel(italic_f_italic_s) == 1);
        assert(numel(italic_L) == 1);

        ret_9 = (italic_s(italic_e, italic_f_italic_s) * (log10(italic_l(italic_L) / italic_l_0)) + 1) * Psi(italic_e, italic_f_italic_s);
    end

    output.italic_l_0 = italic_l_0;
    output.q = q;
    output.italic_l = @italic_l;
    output.italic_g = @italic_g;
    output.Psi = @Psi;
    output.italic_zeta = @italic_zeta;
    output.italic_tau = @italic_tau;
    output.italic_A = @italic_A;
    output.italic_d = @italic_d;
    output.hatPsi = @hatPsi;
    output.italic_s = @italic_s;
    output.m = m;    
    output.italic_f_italic_s_0 = italic_f_italic_s_0;    
    output.italic_p = italic_p;    
    output.a = a;
end

