#!/usr/bin/env ruby
## vim:set ts=2 sw=2 et: -*- coding: utf-8 -*-

$:.insert(0,'.')
$:.uniq!

$title = "conv vb2rb"
require 'yaml'
require 'utf.rb'
require 'color.rb'

@forms = Hash.new(nil)
@sour = Hash.new(nil)
$kv=Hash.new({})

def pr(s)
  puts s
end

alias cat puts
class String
  def adds(s1)
    self << "\r\n" << s1 
  end
  def d
    self.downcase
  end
end

class Form
  attr_accessor :name,:fn
  attr_accessor :kv
  $kv={}
end

def getkv(s,name)
  $kv[name] = Hash.new({}) if not $kv[name]
  pr "getkv #{name}  : #{s} ".blue
  #puts s
  k,v=s.split('=')
  k.gsub!(/^Attribute\s+/i,'')
  k=k.strip.downcase
  v=v.strip
  if v =~ /^"(.*?)"$/i
    v=$1
  end
  pr "k:#{k} , v:#{v} "
  $kv[name][k]=v
end

def scan1 x,name
  form=@forms[name]
  #pr " form: #{form.inspect} "
  pr " scan1 name: #{name}  x:#{x.yellow} ".green
  if x =~ /^form=/i
    k=x.split('=')[1]
    @forms[k]= Form.new
    $kv[name]={}
  elsif x =~ /="/i
    if form.class == Form
      k,v=x.split('=')
      k=k.gsub(/Attribute\s*/i,'').strip.downcase
      v=v.strip
      form.kv[k]=v
      #pr "name: #{name}  #{k} = #{v} "
      $kv[name][k]=v
    else
      #pr " ev2: #{x} "
      eval x
    end
  else
    getkv x,name
  end
end

def readf(fn)
  a=File.new(fn,'rb')
  r=a.read
  a.close
  r
rescue
  p $!
  p fn
end

def getkv2(k,s)
  s.scan(/#{k}\s+=(.*?)$/im)[0]
end

def read_xy(s)
  $caption=getkv2("Caption",s)
  x=s.scan(/ClientLeft\s+=(.*?)$/im)[0]
  #p x
  top=s.scan(/ClientTop\s+=(.*?)$/im)[0]
  #p top
  #p s
end

def read_obj
  pr " sour #{$main} : "
  s=@sour[$main]
  o=@obj['obj']
  o.each{|x|
    p x
    s1=s.scan(/(begin #{x}.*?end)/im)[0]
    pr s1
  }
  #pr s
end

def read_startup frm
  pr " read start up "
  @forms.keys.each{|f|
    ff=@forms[f]
    s=readf(f)
    @sour[f] = s
    s.scan(/Attribute.*/i).each{|x|
      scan1(x,f)
    }
    next
  }
  pr " read #{frm} ".red
  pp @forms
  pr "@forms.kv: #{ @forms['a.frm'].kv } "
  @fn = nil
  $kv.keys.each{|x| 
    pr " frm: #{frm} "
    if $kv[x]['vb_name'] == frm
      p $kv[x].keys
      $main=@fn = x
      pr " set start up fn: #{@fn} "
      break
    end
  }
  pr "fn: #{@fn}".green_on_white
  fn=@fn
  s=readf(fn)
  pos1 = s.index(/begin/i)
  pos2 = s.index(/begin/i,pos1+5)
  #pr s[0..pos2+5]
  main = Startup
  pr s[pos1+5..-1].scan(/begin.*?\send/im)
  s[0..pos2-1].split(/$/).each{|x|
    puts x.strip
    next if x !~ /caption|client(left|top|heig|width)/i 
    #p x
    x.strip!
    k,v=x.split('=')
    k=k.downcase.strip
    v=v.strip
    #pr "fn:#{fn} "
    $kv[fn][k]=v
    #scan1(x,main)
  }
end

def init_obj
  fn='objs.yaml'
  s=readf(fn)
  pr @obj=YAML.load(s)
end

def read_vbp fn
  pr " read vbp ".red_on_white
  j= Dir.entries('.').select{|x| x=~ /.vbp$/i }
  j=fn || j[0]
  pr " read #{fn} , read #{j} ".red
  s=readf(j).to_utf8
  s.split(/$/).each{|x|
    next if x !~ /startup|form|command32|name/i 
    #p x
    x.strip!
    scan1(x,'vbp')
  }
  pr " form: #{@forms} "
  pr "[OK] vbp "
  puts
end

case ARGV[0]
when /-make/i
  $make=true
else
  $fn = ARGV[0]
  pr " fn:#{$fn} ".green if $fn
end
puts ( "_" * 80 ).green_on_white
init_obj
read_vbp $fn
cat "name: " + Name
pr "startup: " + Startup
read_startup Startup
read_obj

def make_tk
  pr " make main.rb "
  s=" ## this file is autogen by cv.rb "
  s.adds "require 'tk' "
  s.adds "root = TkRoot.new{ title #{$caption} } "
  a=$kv[$main]

  x=(a['ClientLeft'.d].to_f / 15).ceil
  y=(a['ClientTop'.d].to_f / 15).ceil
  w=(a['ClientWidth'.d].to_f / 15).ceil
  h=(a['ClientHeight'.d].to_f/15).ceil
  s.adds "root.geometry(\"#{w}x#{h}+#{x}+#{y}\")"
  s.adds "Tk.mainloop "

  puts s.green
  a=File.new('main.rb','wb')
  a.write s
  a.close
end

pr " read ok , make tk \n"
puts
make_tk

exit

def run_tk
  `ruby main.rb`
end
run_tk if not $make


