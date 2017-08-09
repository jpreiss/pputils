function unittest()

	% constant
	pp = pp_constant(1, pi, 11);
	assert(pp.order == 11);
	assert(ppval(pp, 0) == pi);

	% linear
	for i=1:100
		ndim = randi(6);
		dim = randi(6, 1, 6);
		p0 = rand(dim);
		p1 = rand(dim);
		t = 0.1 + 100 * rand();
		order = randi(11) + 1;
		pp = pp_linear(t, p0, p1, order);
		assert(pp.order == order);
		assert(close(ppval(pp, 0), p0));
		assert(close(ppval(pp, t), p1));
		assert(close(ppval(pp, t/2), (p0 + p1) ./ 2));
	end

	% stretch
	for i=1:100
		pp = pp_random();
		factor = exp(4*rand() - 2);
		pps = pp_stretch(pp, factor);
		t0 = pp.breaks(1);
		t1 = pp.breaks(end);
		t = t0 + (t1 - t0) * (0:0.001:1);
		assert(close(t(1), t0));
		assert(close(t(end), t1));
		ts = t0 + factor * (t1 - t0) * (0:0.001:1);
		x = ppval(pp, t);
		xs = ppval(pps, ts);
		assert(close(x, xs));
	end

	% concat
	for i=1:100
		[pp1, pp2] = pp_random();
		dur1 = pp1.breaks(end) - pp1.breaks(1);
		dur2 = pp2.breaks(end) - pp2.breaks(1);
		tbreak = pp1.breaks(end);
		ppc = pp_cat(pp1, pp2);

		tscl = 0:0.001:1;
		tscl = tscl(1:(end-1));
		t1 = pp1.breaks(1) + dur1 * tscl;
		x1 = ppval(pp1, t1);
		x1c = ppval(ppc, t1);
		assert(close(x1, x1c));

		t2 = dur2 * tscl;
		x2 = ppval(pp2, pp2.breaks(1) + t2);
		x2c = ppval(ppc, tbreak + t2);
		assert(close(x2, x2c));
	end

	% is_smooth
	pp = pp_cat(pp_constant(1, 0, 3), ...
	            pp_constant(1, 0, 3));
	assert(pp_is_smooth(pp, 2));
	pp = pp_cat(pp_constant(1, 0, 3), ...
	            pp_constant(1, 1, 3));
	assert(~pp_is_smooth(pp, 0));
	pp = pp_cat(pp_linear(1, 0, 1, 3), ...
	            pp_linear(1, 1, 3, 3));
	assert(pp_is_smooth(pp, 0));
	assert(~pp_is_smooth(pp, 1));
	pp = pp_cat(pp_linear(1, 0, 1, 3), ...
	            pp_linear(1, 1, 2, 3));
	assert(pp_is_smooth(pp, 1));

	% I can't think of a way to test pp_sample_piece
	% other than re-implementing the exact function...

	fprintf('pputils: all tests passed.\n');
end

function c = close(a, b)
	relative_err = abs(a(:) - b(:)) ./ abs(a(:));
	c = all(relative_err < 0.0000001);
end
