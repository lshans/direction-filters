function H = lpfilter(type, M, N, D0)
%% µÍÍ¨ÂË²¨
% compute the required distances
[U, V] = dftuv(M, N);
% compute the distances D(U, V)
 D = hypot(U, V);
% begin filter computations
 switch type
     case 'ideal'
        H = single(D <= D0);
     case 'btw'
         if nargin == 4
             n = 1;
         end
         H = 1./(1 + (D./D0).^(2 * n));
     case 'gaussian'
        H = exp(-(D.^2)./(2 *(D0 ^ 2)));
     otherwise  
         error('Unknown filter type.')
 end