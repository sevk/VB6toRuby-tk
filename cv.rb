#!/usr/bin/env ruby
## vim:set ts=2 sw=2 et: -*- coding: utf-8 -*-

$:.insert(0,'.')
$:.uniq!

$title = "conv vb2rb"
require 'utf.rb'
require 'colored'

def pr(s)
  puts s
end
alias cat puts
class String
  def adds(s1)
    self << "\r\n" << s1 
  end
end

def getkv(s)
  #pr " get kv: #{s} "
  if s =~ /(.*?)=([^"].*)/i
    k=$1
    v=$2
    eval "#{k}='#{v}'"
  end
end

def scan1 x
  p x
  if x =~ /="/i
    eval x
  else
    getkv x
  end
end

def readf(fn)
  a=File.new(fn,'rb')
  r=a.read
  a.close
  r
end

def getkv2(k,s)
  s.scan(/#{k}\s+=(.*?)$/im)[0]
end
def read_xy(s)
  #p Caption
  #title=getkv("Caption",s)
  #p title
  x=s.scan(/ClientLeft\s+=(.*?)$/im)[0]
  p x
  top=s.scan(/ClientTop\s+=(.*?)$/im)[0]
  p top
  #p s
end
def read_frm frm
  pr " read #{frm} ".red
  s=readf(frm)
  puts s

  s.split(/$/).each{|x|
    next if x !~ /caption|client(left|top|heig|width)/i 
    x.strip!
    scan1(x)
  }
  #x,y=read_xy(s)
end

def read_vbp fn
  j= Dir.entries('.').select{|x| x=~ /.vbp$/i }
  p j
  j=fn || j[0]
  pr " read #{fn} , read #{j} ".red
  s=open(j).read.to_utf8
  s.split(/$/).each{|x|
    next if x !~ /startup|form|command32|name/i 
    x.strip!
    scan1(x)
  }
  pr "[OK] vbp "
end
case ARGV[0]
when /-make/i
  $make=true
else
  $fn = ARGV[0]
  pr " fn:#{$fn} "
end
read_vbp $fn
cat Name
cat Form
read_frm Form

def make_tk
  s="require 'tk' "
  s.adds "root = TkRoot.new{ title #{Caption} } "
  x=(ClientLeft.to_f / 15).ceil
  y=(ClientTop.to_f / 15).ceil
  w=(ClientWidth.to_f / 15).ceil
  h=(ClientHeight.to_f/15).ceil
  s.adds "root.geometry(\"#{w}x#{h}+#{x}+#{y}\")"
  s.adds "Tk.mainloop "

  puts s
  a=File.new('main.rb','wb')
  a.write s
  a.close
end
make_tk

def run_tk
  `ruby main.rb`
end
run_tk if not $make


