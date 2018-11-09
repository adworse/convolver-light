require 'helpers'

describe Convolver do
  describe "#convolve" do

    it "should work like the example in the README" do
      a = NArray[ 0.3, 0.4, 0.5 ]
      b = NArray[ 1.3, -0.5 ]
      c = Convolver.convolve( a, b )
      expect( c ).to be_narray_like NArray[ 0.19, 0.27 ]
    end

    it "should process convolutions of different sizes" do
      # The variety here is to ensure all branches of optimisation algorithm
      # are covered
      [10,30,60,90,100,120,130,150,175,200].each do |asize|
        [5,10,12,15,20,30,40,50].each do |bsize|
          next unless bsize < asize
          a = NArray.sfloat(asize,asize).random()
          b = NArray.sfloat(bsize,bsize).random()
          c = Convolver.convolve( a, b )

          # We should always match output of convolve_basic irrespective
          # of what the optimal choice of algorithm is (larger error allowed here due to rounding)
          expect_result = Convolver.convolve_basic( a, b )
          expect( c ).to be_narray_like( expect_result, 1e-6 )
        end
      end
    end

    it "should choose #convolve_basic for small inputs" do
      a = NArray.sfloat(50,50).random()
      b = NArray.sfloat(10,10).random()
      expect(Convolver).to receive(:convolve_basic).once
      expect(Convolver).to_not receive(:convolve_fftw3)
      c = Convolver.convolve( a, b )
    end

  end

end
