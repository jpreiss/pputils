function pp = pp_select_pieces(pp, indices)
	if isempty(indices)
		pp = [];
		return;
	end

	[breaks, coefs, pieces, order, dim] = unmkpp(pp);
	start = breaks(1);
	durations = diff(breaks);

	coefs = reshape(coefs, [prod(dim) pieces order]);
	coefs = coefs(:,indices,:);
	durations = durations(indices);
	breaks = cumsum([start durations]);

	pp = mkpp(breaks, coefs, dim);
end
