proc iml ;
/* Model parameters */
n = 201;
centre = ceil (n/2);

Tas = j(n, n, 0);
Tas [centre , centre ] = 400000;

/* Critical threshold */
do while (max (Tas ) >= 4);

	idx = loc(Tas >= 4); /* locate the cells to topple */
	if ncol (idx )=0 then leave ;

	/* Positions (r,c) of these cells */
	rr = ceil (idx / n);
	cc = idx - (rr - 1)*n; *or "cc = mod(idx - 1, n) + 1";

	/* Remove 4 grains simultaneously */
	do k = 1 to ncol (idx );
		Tas[ rr[k], cc[k] ] = Tas[ rr[k], cc[k] ] - 4;
	end;

	/* Accumulate redistributed grains */
	Add = j(n,n ,0); *Add stores the grains redistributed to neighbours ;

	do k = 1 to ncol (idx );
		r = rr[k]; c = cc[k];
		if r>1 then Add [r -1,c] = Add [r -1,c] + 1; /* up */
		if r<n then Add [r+1,c] = Add [r+1,c] + 1; /* down */
		if c>1 then Add [r,c -1] = Add [r,c -1] + 1; /* left */
		if c<n then Add [r,c+1] = Add [r,c+1] + 1; /* right */
	end;

	Tas = Tas + Add; /* update the grid */
end ;

/* Visualisation : Heatmap */
Sandpile = mod(Tas , 4);
call heatmapdisc ( Sandpile )
	xvalues =1: n yvalues =1:n
	title =" Abelian sandpile (201 x201 , 400000 grains )"
	displayoutlines =0;
quit ;
