% evaluates the entire i'th piece of the piecewise polynomial
% at n evenly spaced points.
function pts = pp_sample_piece(pp, i, n)
	t0 = pp.breaks(i);
	t1 = pp.breaks(i + 1);
	dt = (t1 - t0) / (n - 1);
	t = t0 + dt * (0:(n - 1));
	% TODO relative
	t(end) = t1 - 10e-12;
	assert(t1 > t(end));
	assert(t1 - t(end) < 10e-9);
	pts = ppval(pp, t);
end
