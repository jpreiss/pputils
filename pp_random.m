% returns a piecewise polynomial with everything randomized -
% output dimension, number of pieces, order, breaks.
%
% if called with multiple output arguments,
% returns multiple pps with same dimension and order,
% but different coefs, npieces, and breaks.
%
% mostly useful for testing.
function varargout = pp_random()
	ndim = randi(4);
	dim = randi(4, 1, ndim);
	order = randi(10) + 1;

	varargout = cell(1,nargout);
	for i=1:nargout
		npiece = randi(10);
		breaks = cumsum(2*rand(1, npiece + 1));
		coefs = randn(prod(dim), npiece, order);
		pp = mkpp(breaks, coefs, dim);
		varargout{i} = pp;
	end
end
