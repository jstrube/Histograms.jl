# Histograms.jl
Facilities for histogramming of transient data

[![Build Status](https://travis-ci.org/jstrube/Histograms.jl.svg?branch=master)](https://travis-ci.org/jstrube/Histograms.jl)

[![Coverage Status](https://coveralls.io/repos/jstrube/Histograms.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jstrube/Histograms.jl?branch=master)

[![codecov.io](http://codecov.io/github/jstrube/Histograms.jl/coverage.svg?branch=master)](http://codecov.io/github/jstrube/Histograms.jl?branch=master)

The bins are chosen ahead of time in the constructor.
Bins are implemented as an array of left edges. Bin[1] is the underflow, bin[end] is the overflow bin.
The constructor `H1D(100, 0, 1)` creates the bin edges as `linspace(0, 1, 101)`, and the contents as `zeros(102)`.
Data is then accumulated in `bins[2:end-1]` (except for underflow and overflow, obviously).

TODO: still need to make the -1 offset between bins and edges more difficult to get wrong.
