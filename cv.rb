#!/usr/bin/env ruby
## vim:set ts=2 sw=2 et: -*- coding: utf-8 -*-

$:.insert(0,'.')
$: << "lib"
$: << '/home/kk/rec/rec/lib'
$:.uniq!

if ENV["HOME"] =~ /\/home/
  $: << "~/rec/rec/"
  $: << "~/rec/rec/lib"
else
  $: << "D:/Jnew/program/rec/"
  $: << "D:/Jnew/program/rec/lib"
end
$: << "lib"
$: << "../lib"
$: << ".."
$: << "."
$:.uniq!

$title = "conv vb2rb"
require "title.rb"
require 'kkbin.rb'

def getkv(s)
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

def read_frm frm
  pr " read #{frm} ".red
  s=readf(frm)
  puts s

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
  #cat a
end
fn = ARGV[0]
pr " fn:#{fn} "
read_vbp fn
cat Name
cat Form
read_frm Form
#Object.constants.each{|x| p x }

