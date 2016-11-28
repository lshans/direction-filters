function PQ = paddedsize(AB, CD, PARAM)
if nargin == 1
    PQ = 2 * AB
elseif nargin == 2 && ~ischar(CD)
    PQ = AB + CD - 1
    PQ = 2 * ceil(PQ / 2);
elseif nargin == 2
    m = max(AB)
    P = 2 ^nextpow2(2 * m);
    PQ = [P, P];
else
    error('wrong number of input.')
end