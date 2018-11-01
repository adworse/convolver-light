# Convolver-Light

This is native-only version of [neilslater's](https://github.com/neilslater) [Convolver Gem](https://github.com/neilslater/convolver)

FFTW3 dependency is removed, so calculations would be slow on big matrices. Use it only if you need to make a convolution with a small kernel.

All the credits to the [author](https://github.com/neilslater)

### Installing the gem

Add this line to your application's Gemfile:

    gem 'convolver-light'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install convolver-light

## Usage

    require 'convolver-light

Usage is exactly the same as of original gem, please refer to the [author's page](https://github.com/neilslater/convolver)

```
a = NArray[0.3,0.4,0.5]
b = NArray[1.3, -0.5]
c = Convolver.convolve( a, b )
=> NArray.float(2): [ 0.19, 0.27 ]
```
