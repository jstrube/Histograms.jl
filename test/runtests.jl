using Histograms
using Base.Test

NENTRIES = 10000
x = randn(NENTRIES)
h1 = H1D(100, 0, 10)
for i in x
    hfill!(h1, i)
end
@test sum(h1.entries) == NENTRIES

h2 = H2D(100, 0, 10, 100, 0, 10)
y = randn(NENTRIES)
for i = 1:NENTRIES
    hfill!(h2, x[i], y[i])
end
@test sum(h2.entries) == NENTRIES
