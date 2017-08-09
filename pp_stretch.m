% scales the breaks of the piecewise polynomial.
% i.e. if pp has breaks [1, ..., 3], ppstretch has breaks [1, ..., 5]
% and evaluates to the same values over that interval.
function ppstretch = pp_stretch(pp, scale)
	[breaks, coefs, k, order, dim] = unmkpp(pp);
	t0 = breaks(1);
	breaks = scale * (breaks - t0) + t0;

	coefs = reshape(coefs, [prod(dim) k order]);
	for i=1:k
		for d=1:prod(dim)
			coefs(d,i,:) = polystretchtime(coefs(d,i,:), scale);
		end
	end

	ppstretch = mkpp(breaks, coefs, dim);
end

function p = polystretchtime(p, s)
	p = flip(p);
	recip = 1.0 / s;
	scale = recip;
	order = length(p);
	for i=2:order
		p(i) = scale * p(i);
		scale = scale * recip;
	end
	p = flip(p);
end
