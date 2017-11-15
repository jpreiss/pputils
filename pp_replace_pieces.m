function pp = pp_replace_pieces(ppbase, indices, ppsplice)
	% must be contiguous range
	assert(all(diff(indices) == 1));
	i1 = indices(1);
	iend = indices(end);

	before = pp_select_pieces(ppbase, 1:(i1-1));
	after = pp_select_pieces(ppbase, (iend+1):ppbase.pieces);
	pp = pp_cat(before, ppsplice, after);
end
