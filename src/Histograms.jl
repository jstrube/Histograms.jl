module Histograms
using Plots
using JLD
export H1D, H2D, fill

type Histogram1D
    """
    This is a one-dimensional histogram with full outlier handling.
    The convention for numbering the bins is:
    start from 1.
    If you care about all entries,
    set the left edge of the first bin to -inf,
    the right edge of the last bin to +inf
    """
    binEdges
    entries
    weights
    weights_squared
    torques
    inertials
end

H1D() = Histogram1D()
H2D() = Histogram2D()

function fill(h::Histogram1D, x, weight=1.)
    index = find_index(h, x)
    if index < 0
        return
    end
    h.entries[index] += 1
    h.weights[index] += weight
    h.weights_squared[index] += weight*weight
    h.torques[index] += x*weight
    h.inertials[index] += x*x*weight
end

function find_index(h::Histogram1D, x):
    """
    Returns the index of the bin that this item would be put into
    """
    if x < self.binEdges[0]
        return -1
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    for (i, edge) in enumerate(self.binEdges[1:end])
        if x < edge
            return i
        end
    end
end

stddev(h::Histogram1D) = sum(h.torques)
mean(h::Histogram1D) = sum(h.entries)
function +(h1::Histogram1D, h2::Histogram1D)
    if ! all(self.binEdges == other.binEdges)
        println("ERROR! The bin egdes must be the same for both histograms")
        return
    end
    entries = h1.entries + h2.entries
    weights = h1.weights + h2.weights
    weights_squared = h1.weights_squared + h2.weights_squared
    return Histogram1D(edges, entries, weights, weights_squared)
end

type Histogram2D
    # this is just a list of vectors (x, y)
    binEdges
    entries
    weights
    weights_squared
    torquesX
    torquesY
    inertialsX
    inertialsY
end

function find_index(h::Histogram2D, x, y)
    if x < self.binEdges[0]
        return -1
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    for (i, edge) in enumerate(self.binEdges[1,1:end])
        if x < edge
            break
        end
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    for (j, edge) in enumerate(self.binEdges[2,1:end])
        if y < edge
            break
        end
    end
    return i,j
end

function fill(h::Histogram2D, x, y, weight = 1.0)
    i,j = find_index(h, x, y)
    h.entries[i,j] += 1
    h.weights[i,j] += weight
    h.weights_squared[i,j] += weight^2
    h.torquesX[i,j] += x * weight
    h.torquesY[i,j] += y * weight
    h.inertialsX[i,j] += x^2 * weight
    h.inertialsY[i,j] += y^2 * weight
end

function getStatisticSet(h::Histogram2D)
    weights = sum(h.weights)
	torquesX = sum(h.torquesX)
	torquesY = sum(h.torquesY)

	entries = h.entries
	meanX = torquesX / weights
	meanY = torquesY / weights

    rmsX = sqrt((sum(h.inertialsX) - torquesX^2 / weights) / weights)
	rmsY = sqrt((sum(h.inertialsY) - torquesY^2 / weights) / weights)
	return entries, meanX, meanY, rmsX, rmsY
end

function plot(h::Histogram1D)
    prinln("Not yet implemented")
end

function plot(h::Histogram2D)
    xs = h.egdes[1]
    ys = h.edges[2]
    z = h.weights
    heatmap(xs,ys,z,aspect_ratio=1)
end

function save(h::Histogram2D, histname, filename)
    jldopen(filename, "w") do file
        addrequire(file, Histogram)
        write(file, histname, h)
    end
end

end
