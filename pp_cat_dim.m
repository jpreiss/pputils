% concatenates the outputs of the polynomials along the given dimension.
% for example,
% if:
%     pp1(t) == [1 0]
%     pp2(t) == [1 2 3]
%     pp = pp_cat_dim(2, pp1, pp2)
% then:
%     pp(t) == [1 0 1 2 3]
%
function pp = pp_cat_dim(catdim, pp1, pp2)
	[breaks1, coefs1, k1, order1, dim1] = unmkpp(pp1);
	[breaks2, coefs2, k2, order2, dim2] = unmkpp(pp2);
	assert(all(breaks1 == breaks2));
	assert(k1 == k2);
	% TODO: could relax
	assert(order1 == order2);

	ndims = length(dim1);
	assert(catdim >= 1);
	assert(catdim <= ndims);
	other_dims = 1:ndims ~= catdim;
	assert(all(dim1(other_dims) == dim2(other_dims)));

	coefs1 = reshape(coefs1, [dim1 k1 order1]);
	coefs2 = reshape(coefs2, [dim2 k2 order2]);

	coefs = cat(catdim, coefs1, coefs2);
	dim = dim1;
	dim(catdim) = dim1(catdim) + dim2(catdim);
	pp = mkpp(breaks1, coefs, dim);
end
