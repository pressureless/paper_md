function output = Anisotropic(a, C)
% output = Anisotropic(a, C)
%
%     A = a a^T 
%    tr from linearalgebra
%    `$I_5$` = tr(CA)
%    
%    where
%    
%    a ∈ ℝ^3
%    C ∈ ℝ^(3×3)
%    
%    `$\frac{∂²I₅}{∂f²}$` = 2[A₁,₁I₃  A₁,₂I₃  A₁,₃I₃
%                   A₂,₁I₃  A₂,₂I₃  A₂,₃I₃
%                   A₃,₁I₃  A₃,₂I₃  A₃,₃I₃] 
%    
%    
%    
    if nargin==0
        warning('generating random input data');
        [a, C] = generateRandomData();
    end
    function [a, C] = generateRandomData()
        a = randn(3,1);
        C = randn(3, 3);
    end

    a = reshape(a,[],1);

    assert( numel(a) == 3 );
    assert( isequal(size(C), [3, 3]) );

    % A = a a^T 
    A = reshape(a, [3, 1]) * a';
    % `$I_5$` = tr(CA)
    I_5 = trace(C * A);
    % `$\frac{∂²I₅}{∂f²}$` = 2[A₁,₁I₃  A₁,₂I₃  A₁,₃I₃
    %                A₂,₁I₃  A₂,₂I₃  A₂,₃I₃
    %                A₃,₁I₃  A₃,₂I₃  A₃,₃I₃] 
    frac_partial_differential_2I5_partial_differential_f2_0 = [[A(1, 1) * speye(3), A(1, 2) * speye(3), A(1, 3) * speye(3)]; [A(2, 1) * speye(3), A(2, 2) * speye(3), A(2, 3) * speye(3)]; [A(3, 1) * speye(3), A(3, 2) * speye(3), A(3, 3) * speye(3)]];
    frac_partial_differential_2I5_partial_differential_f2 = 2 * frac_partial_differential_2I5_partial_differential_f2_0;
    output.A = A;
    output.I_5 = I_5;
    output.frac_partial_differential_2I5_partial_differential_f2 = frac_partial_differential_2I5_partial_differential_f2;
end

