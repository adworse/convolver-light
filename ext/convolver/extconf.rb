# ext/convolver/extconf.rb
require "mkmf"
require "rubygems"

# Following code stolen shamelessly from fftw3 gem:
narray_dir = File.dirname(Gem.find_files("narray.h").first) rescue $sitearchdir

if /cygwin|mingw/ =~ RUBY_PLATFORM
  dir_config('narray', narray_dir, "#{narray_dir}/src")
else
  dir_config('narray', narray_dir, narray_dir)
end

if ( ! ( have_header("narray.h") && have_header("narray_config.h") ) ) then
   print <<-EOS
   ** configure error **
   Header narray.h or narray_config.h is not found. If you have these files in
   /narraydir/include, try the following:

   % ruby extconf.rb --with-narray-include=/narraydir/include

EOS
   exit(-1)
end

# This also stolen from fftw3 gem (and not confirmed for Windows platforms - please let me know if it works!)
if /cygwin|mingw/ =~ RUBY_PLATFORM
   have_library("narray") || raise("ERROR: narray library is not found")
end

$CFLAGS << ' -O3 -funroll-loops'
create_makefile( 'convolver/convolver' )
