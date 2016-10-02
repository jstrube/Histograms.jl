using Histograms
using Base.Test

x = randn(10000)
h1 = H1D(100, 0, 10)
for i in x
    hfill!(h1, i)
end

h2 = H2D(100, 0, 10, 100, 0, 10)
y = randn(10000)
for i = 1:10000
    hfill!(h2, x[i], y[i])
end
