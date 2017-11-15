% check if the piecewise polynomial is smooth.
% i.e. if order==2 checks up thru the 2nd derivative.
% returns boolean.
function ok = pp_is_smooth(pp, order, tolerance)
	if nargin < 3
		tolerance = 0.0000001;
	end
	EPS = 0.0000000001;
	for i=0:order
		splices = pp.breaks(2:(end-1));
		for t=splices
			t0 = t-EPS;
			t1 = t+EPS;
			x0 = ppval(pp, t0);
			x1 = ppval(pp, t1);
			if ~close(x0, x1, tolerance)
				ok = false;
				return;
			end
		end
		pp = fnder(pp);
	end
	ok = true;
end

function c = close(a, b, tolerance)
	relative_err = abs(a(:) - b(:));
	nz = a ~= 0;
	relative_err(nz) = relative_err(nz) ./ abs(a(nz));
	c = all(relative_err < tolerance);
end
