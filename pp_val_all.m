function y = pp_val_all(pp, npts)
	t0 = pp.breaks(1);
	t1 = pp.breaks(end);
	t = linspace(t0, t1, npts);
	y = ppval(pp, t);
end
