module Histograms
using Plots
using JLD
import Base: +
export H1D, H2D, hfill!, hsave

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
# the edges must be sorted
# we add two bins, for underflow and overflow
Histogram1D(nBins, min, max) = Histogram1D(
      # the last edge is the overflow
      # linspace gives us nBins _edges_
      # we'll add 1 to get the right number of bins
      linspace(min, max, nBins+1)
    , zeros(Int64, nBins+2)
    , zeros(nBins+2)
    , zeros(nBins+2)
    , zeros(nBins+2)
    , zeros(nBins+2)
)
H1D(nBins, min, max) = Histogram1D(nBins, min, max)

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
H2D(nBinsX, minX, maxX, nBinsY, minY, maxY) = Histogram2D(nBinsX, minX, maxX, nBinsY, minY, maxY)
Histogram2D(nBinsX, minX, maxX, nBinsY, minY, maxY) = Histogram2D(
      (linspace(minX, maxX, nBinsX+1), linspace(minY, maxY, nBinsY+1))
    , zeros(Int64, (nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
    , zeros((nBinsX+2, nBinsY+2))
)

function find_index(h::Histogram1D, x):
    """
    Returns the index of the bin that this item would be put into
    """
    # underflow
    if x < h.binEdges[1]
        return 1
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    @inbounds for i in 2:length(h.binEdges)
        if x < h.binEdges[i]
            return i-1
        end
    end
    # overflow
    return length(h.binEdges)+1
end

function hfill!(h::Histogram1D, x, weight=1.)
    index = find_index(h, x)
    h.entries[index] += 1
    h.weights[index] += weight
    h.weights_squared[index] += weight*weight
    h.torques[index] += x*weight
    h.inertials[index] += x*x*weight
    return
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


function find_index(h::Histogram2D, x, y)
    # underflow
    i = 0
    if x < h.binEdges[1][1]
        i = 1
    end
    j = 0
    if y < h.binEdges[2][1]
        j = 1
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    if i == 0
        @inbounds for i in 2:length(h.binEdges[1])
            if x < h.binEdges[1][i]
                break
            end
        end
    end
    # we shift the index of the binEgdes by starting at 1
    # thats why we return i rather than i-1
    if j == 0
        @inbounds for j in 2:length(h.binEdges[2])
            if y < h.binEdges[2][j]
                break
            end
        end
    end
    return i,j
end

function hfill!(h::Histogram2D, x, y, weight = 1.0)
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
    xs = h.binEdges[1]
    ys = h.binEdges[2]
    z = h.weights'[1:end-1, 1:end-1]
    heatmap(xs,ys,z)
end

function hsave(h::Histogram1D, histname, filename)
    jldopen(filename, "w") do file
        addrequire(file, Histograms)
        write(file, histname, h)
    end
end

function hsave(h::Histogram2D, histname, filename)
    jldopen(filename, "w") do file
        addrequire(file, Histograms)
        write(file, histname, h)
    end
end

end
