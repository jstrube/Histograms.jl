# Histograms.jl
Facilities for histogramming of transient data

[![Build Status](https://travis-ci.org/jstrube/Histograms.jl.svg?branch=master)](https://travis-ci.org/jstrube/Histograms.jl)

[![Coverage Status](https://coveralls.io/repos/jstrube/Histograms.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jstrube/Histograms.jl?branch=master)

[![codecov.io](http://codecov.io/github/jstrube/Histograms.jl/coverage.svg?branch=master)](http://codecov.io/github/jstrube/Histograms.jl?branch=master)

The bins are chosen ahead of time in the constructor.
Bins are implemented as an array of left edges. Bin[1] is the underflow, bin[end] is the overflow bin.
The constructor `H1D(100, 0, 1)` creates the bin edges as `linspace(0, 1, 101)`, and the contents as `zeros(102)`.
Data is then accumulated in `bins[2:end-1]` (except for underflow and overflow, obviously).

Example:
To create a 2D histogram with 1000 bins from 0-100 GeV, 100 bins for cosTheta:
`h2 = H2D(1000, 0, 100, 100, -1, 1)`
To select all particles > 2.0 GeV, |cosTheta| < 0.7
`h2.weights[22:end,17:end-16]`

TODO: still need to make the -1 offset between bins and edges more difficult to get wrong.
TODO: Use si units for bins?
