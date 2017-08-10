% concatenates any number of piecewise polynomials.
function pp = pp_cat(varargin)
	if nargin == 0
		pp = [];
	elseif nargin == 1
		pp = varargin{1};
	else
		split = floor(nargin / 2);
		pp_left = pp_cat(varargin{1:split});
		pp_right = pp_cat(varargin{(split+1):nargin});
		pp = pp_cat_2(pp_left, pp_right);
	end
end

function pp = pp_cat_2(pp1, pp2)
	if isempty(pp1)
		pp = pp2;
	elseif isempty(pp2)
		pp = pp1;
	else
		[breaks1, coefs1, npiece1, order1, dim1] = unmkpp(pp1);
		[breaks2, coefs2, npiece2, order2, dim2] = unmkpp(pp2);
		assert(all(dim1 == dim2));
		assert(order1 == order2); % TODO could handle this if desired
		ndim = length(dim1);
		coefs1 = reshape(coefs1, [dim1 npiece1 order1]);
		coefs2 = reshape(coefs2, [dim2 npiece2 order2]);
		breaks2 = breaks2 - breaks2(1) + breaks1(end);
		breaks = [breaks1 breaks2(2:end)];
		coefs = cat(ndim + 1, coefs1, coefs2);
		assert(all(size(coefs) == [dim1 npiece1 + npiece2 order1]));
		pp = mkpp(breaks, coefs, dim1);
	end
end
