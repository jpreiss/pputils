function unittest()

	% constant
	pp = pp_constant(1, pi, 11);
	assert(pp.order == 11);
	assert(ppval(pp, 0) == pi);
	pp = pp_constant(2, magic(3), 3);
	assert(pp.order == 3);
	is_eq = ppval(pp, 1.23) == magic(3);
	assert(all(is_eq(:)));

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
		npps = randi(6) - 1;
		pps = pp_random(npps);
		ppc = pp_cat(pps{:});

		if npps == 0
			assert(isempty(ppc));
		else
			% not [0, 1] bc float errors
			tscl = 0.001:0.001:0.999;
			t0_cat = pps{1}.breaks(1);
			for j=1:npps
				t0 = pps{j}.breaks(1);
				dur = pps{j}.breaks(end) - t0;
				xj = ppval(pps{j}, t0 + dur * tscl);
				xc = ppval(ppc, t0_cat + dur * tscl);
				assert(close(xj, xc));
				t0_cat = t0_cat + dur;
			end
		end
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

	% cat_dim
	pp1 = pp_constant(1, [1 0], 3);
	pp1 = pp_cat(pp1, pp1); % to have breaks
	pp2 = pp_constant(1, [1 2 3], 3);
	pp2 = pp_cat(pp2, pp2);
	pp = pp_cat_dim(2, pp1, pp2);
	val = ppval(pp, 1.3);
	assert(all(val == [1 0 1 2 3]));

	% I can't think of a way to test pp_sample_piece
	% other than re-implementing the exact function...

	fprintf('pputils: all tests passed.\n');
end

function c = close(a, b)
	relative_err = abs(a(:) - b(:)) ./ abs(a(:));
	c = all(relative_err < 0.0000001);
end
