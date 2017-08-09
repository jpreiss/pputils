% returns a piecewise polynomial of given order that
% is stationary at p over the time interval [0, t].
% dimensionality of p is unrestricted.
function pp = pp_constant(t, p, order)
	sz = size(p);
	coefs = zeros([prod(sz) order]);
	coefs(:,end) = p(:);
	breaks = [0 t];
	pp = mkpp(breaks, coefs, sz);
end
