require 'mkmf'

#Copied from ruby-filemagic (https://github.com/blackwinter/ruby-filemagic/blob/master/ext/filemagic/extconf.rb)
HEADER_DIRS = [
  '/opt/local/include', # MacPorts
  '/usr/local/include', # compiled from source and Homebrew
  '/usr/include'        # system
]
LIB_DIRS = [
  '/opt/local/lib', # MacPorts
  '/usr/local/lib', # compiled from source and Homebrew
  '/usr/lib'        # system
]
dir_config('wkhtmltox', HEADER_DIRS, LIB_DIRS)

unless have_library('wkhtmltox')
  abort('Missing wkhtmltox library')
end
  
unless have_header('wkhtmltox/pdf.h')
  abort('Missing wkhtmltox pdf.h')
end

unless have_header('wkhtmltox/image.h')
  warn('Missing wkhtmltox image.h')
end

#--enable-use-graphics/--disable-use-graphics
if enable_config('use-graphics')
  $defs.push('-DUSE_GRAPHICS')
end

create_makefile('wkhtml/wkhtml_native')