% returns n piecewise polynomials with everything randomized -
% output dimension, number of pieces, order, breaks.
% mostly useful for testing.
% if called with no argument, returns a single pp struct.
function pps = pp_random(n)
	ndim = randi(4);
	dim = randi(4, 1, ndim);
	order = randi(10) + 1;

	if nargin == 0
		n = 1;
	end

	pps = cell(n,1);
	for i=1:n
		npiece = randi(10);
		breaks = cumsum(2*rand(1, npiece + 1));
		coefs = randn(prod(dim), npiece, order);
		pp = mkpp(breaks, coefs, dim);
		pps{i} = pp;
	end

	if nargin == 0
		pps = pps{1};
	end
end
