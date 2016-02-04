#0.10.0 first version

<<-COMMENT
HEADER_DIRS = [
  '/opt/local/include', # MacPorts
  '/usr/local/include', # compiled from source and Homebrew
  '/usr/include',       # system
]

LIB_DIRS = [
  '/opt/local/lib', # MacPorts
  '/usr/local/lib', # compiled from source and Homebrew
  '/usr/lib',       # system
]

$CFLAGS << ' -Wall' if ENV['WALL']
$LDFLAGS << ' -static-libgcc' if RUBY_PLATFORM =~ /cygwin|mingw|mswin/

dir_config('magic', HEADER_DIRS, LIB_DIRS)
dir_config('gnurx', HEADER_DIRS, LIB_DIRS)

if have_library('magic', 'magic_open') && have_header('magic.h')
  have_func('magic_version')
  have_header('file/patchlevel.h')
  create_makefile('filemagic/ruby_filemagic')
else
  abort '*** ERROR: missing required library to compile this module'
end



require 'mkmf'

CWD = File.expand_path(File.dirname(__FILE__))
def sys(cmd)
  puts "  -- {cmd}"
  unless ret = xsystem(cmd)
    raise "{cmd} failed, please report issue on https://github.com/brianmario/charlock_holmes"
  end
  ret
end

if `which make`.strip.empty?
  STDERR.puts "\n\n"
  STDERR.puts "***************************************************************************************"
  STDERR.puts "*************** make required (apt-get install make build-essential) =( ***************"
  STDERR.puts "***************************************************************************************"
  exit(1)
end

##
# ICU dependency
#

dir_config 'icu'

rubyopt = ENV.delete("RUBYOPT")
# detect homebrew installs
if !have_library 'icui18n'
  base = if !`which brew`.empty?
    `brew --prefix`.strip
  elsif File.exists?("/usr/local/Cellar/icu4c")
    '/usr/local/Cellar'
  end

  if base and icu4c = Dir[File.join(base, 'Cellar/icu4c/*')].sort.last
    $INCFLAGS << " -I{icu4c}/include "
    $LDFLAGS  << " -L{icu4c}/lib "
  end
end

unless have_library 'icui18n' and have_header 'unicode/ucnv.h'
  STDERR.puts "\n\n"
  STDERR.puts "***************************************************************************************"
  STDERR.puts "*********** icu required (brew install icu4c or apt-get install libicu-dev) ***********"
  STDERR.puts "***************************************************************************************"
  exit(1)
end

have_library 'z' or abort 'libz missing'
have_library 'icuuc' or abort 'libicuuc missing'
have_library 'icudata' or abort 'libicudata missing'

$CFLAGS << ' -Wall -funroll-loops'
$CFLAGS << ' -Wextra -O0 -ggdb3' if ENV['DEBUG']

ENV['RUBYOPT'] = rubyopt
create_makefile 'charlock_holmes/charlock_holmes'
Status API Training Shop Blog About Pricing
 2016 GitHub, Inc. Terms Privacy Security Contact Help
COMMENT

#https://blog.jcoglan.com/2012/07/29/your-first-ruby-native-extension-c/
#http://patshaughnessy.net/2011/10/31/dont-be-terrified-of-building-native-extensions
#http://clalance.blogspot.com/2011/01/writing-ruby-extensions-in-c-part-3.html
#https://silverhammermba.github.io/emberb/

require 'mkmf'

HEADER_DIRS = [
  '/opt/local/include', # MacPorts
  '/usr/local/include', # compiled from source and Homebrew
  '/usr/include',       # system
]
LIB_DIRS = [
  '/opt/local/lib', # MacPorts
  '/usr/local/lib', # compiled from source and Homebrew
  '/usr/lib',       # system
]
dir_config('wkhtmltox', HEADER_DIRS, LIB_DIRS)

unless have_library('wkhtmltox')
  abort('Missing library')
end
  
unless have_header('wkhtmltox/pdf.h')
  abort('Missing pdf.h')
end

unless have_header('wkhtmltox/image.h')
  warn('Missing image.h')
end


#dir_config('wkhtml')
create_makefile('wkhtml')

