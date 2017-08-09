% returns a piecewise polynomial of given order that linearly interpolates
% between p0 and p1 with constant velocity over the time interval [0, t].
% dimensionality of p0 and p1 is unrestricted.
function pp = pp_linear(t, p0, p1, order)
	sz = size(p0);
	assert(all(size(p1) == sz));
	coefs = zeros([prod(sz) order]);
	coefs(:,end) = p0(:);
	coefs(:,end-1) = (p1(:) - p0(:)) ./ t;
	breaks = [0 t];
	pp = mkpp(breaks, coefs, sz);
end
