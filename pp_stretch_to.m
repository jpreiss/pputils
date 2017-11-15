% scales the breaks of the piecewise polynomial
% i.e. if pp has breaks [1, ..., 3], pp_stretch_to(pp, 4) has breaks [1, ..., 5]
% and evaluates to the same values over that interval.
function ppstretch = pp_stretch_to(pp, t)
	t0 = pp.breaks(end) - pp.breaks(1);
	scale = t / t0;
	ppstretch = pp_stretch(pp, scale);
	% in case it needs to be exact
	ppstretch.breaks(end) = ppstretch.breaks(1) + t;
end
