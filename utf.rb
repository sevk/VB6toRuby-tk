#!/usr/bin/env ruby -w
# -*- coding: UTF-8 -*-
# ruby utf8 gb2312 gbk gb18030 转换库

require 'rubygems'
#p RUBY_VERSION[0,3]
if RUBY_VERSION > '1.9'
   Ig = ''
   #Ig = '//IGNORE'
   if RUBY_VERSION >= '1.9.2'
      $ec1 = Encoding::Converter.new("UTF-16lE", "UTF-8", :universal_newline => true)
      $ec2 = Encoding::Converter.new("UTF-8","GB18030", :universal_newline => true)
      $ec3 = Encoding::Converter.new("UTF-16lE", "GB18030", :universal_newline => true)
      $ecutf8 = Encoding::Converter.new("GBK","UTF-8", :universal_newline => true)
   else
      require 'iconv'
   end
else
   require 'iconv'
   Ig = '//IGNORE'
end

class String
   def code_a2b(a,b)
     return self if a =~ /#{b}/i
      if RUBY_VERSION > '1.9' and defined? Encoding::Converter
        tmp = Encoding::Converter.new(a,b, :universal_newline => true)
        tmp.convert self rescue self
      else
        Iconv.conv("#{b}//IGNORE","#{a}//IGNORE",self)
      end
   end
   #自动判断
   def togb2312
     return $ec2.convert(self) if RUBY_VERSION >= '1.9.2'
      Iconv.conv("CP20936#{Ig}","UTF-8#{Ig}",self)
   end
   def togbk
     if RUBY_VERSION >= '1.9.2'
       $ec2.convert self rescue self
     else
       Iconv.conv("GB18030#{Ig}","UTF-8#{Ig}",self)
     end
   end
   def togb
     if RUBY_VERSION >= '1.9.2'
       $ec2.convert self rescue self
     else
       Iconv.conv("GB18030#{Ig}","UTF-8#{Ig}",self)
     end
   end
   alias to_gb togb

   def utf8_to_gb
     return $ec2.convert(self) if RUBY_VERSION >= '1.9.2'
     Iconv.conv("GB18030#{Ig}","UTF-8#{Ig}",self)
   end
   def gb_to_utf8
     return $ecutf8.convert(self) if RUBY_VERSION >= '1.9.2'
     Iconv.conv("UTF-8#{Ig}","GB18030#{Ig}",self)
   end
   def to_utf8
     return $ecutf8.convert(self) if RUBY_VERSION >= '1.9.2'
     Iconv.conv("UTF-8#{Ig}","GB18030#{Ig}",self)
   rescue
     self
   end

   def uni_to_gb
     return $ec3.convert(self) if RUBY_VERSION >= '1.9.2'
     Iconv.conv("GB18030#{Ig}","UTF-16#{Ig}",self)
   end
   def uni_to_utf8
     return $ec1.convert(self) if RUBY_VERSION >= '1.9.2'
     Iconv.conv("UTF-8#{Ig}","UTF-16",self)
   end
end
#print '中文 '.togb

