require 'narray'
require "convolver/convolver"
require "convolver/version"

module Convolver
  # Chooses and calls likely fastest method from #convolve_basic and #convolve_fftw3.
  # The two parameters must have the same rank. The output has same rank, its size in each
  # dimension d is given by
  #  signal.shape[d] - kernel.shape[d] + 1
  # If you always perform convolutions of the same size, you may be better off benchmarking your
  # own code using either #convolve_basic or #convolve_fftw3, and have your code use the fastest.
  # @param [NArray] signal must be same size or larger than kernel in each dimension
  # @param [NArray] kernel must be same size or smaller than signal in each dimension
  # @return [NArray] result of convolving signal with kernel
  def self.convolve(signal, kernel)
    convolve_basic signal, kernel
  end
end
