require 'narray'
require "convolver/convolver"
require "convolver/version"

module Convolver
  # The two parameters must have the same rank. The output has same rank, its size in each
  # dimension d is given by
  #  signal.shape[d] - kernel.shape[d] + 1
  # @param [NArray] signal must be same size or larger than kernel in each dimension
  # @param [NArray] kernel must be same size or smaller than signal in each dimension
  # @return [NArray] result of convolving signal with kernel
  def self.convolve(signal, kernel)
    convolve_basic signal, kernel
  end
end
