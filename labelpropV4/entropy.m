function E = entropy(p)
	L = log2(p);
	L(L == -Inf) = 0;
	E = -sum(p .* L);
