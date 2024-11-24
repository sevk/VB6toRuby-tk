
~/ts :
	ruby cv.rb --make
	@echo
	@echo output ::
	ls -al main.rb
fl = `ls */*.rb -atL | head -n 3 ` `ls *.rb  -atL | head -n 3`

install : ~/ts
	echo $(fl)
	cp -uv $(fl) /tmp/RDP/
.PHONY :  tags
tags :
	ctags *.c 
	find -iregex ".*?\(.akefile|cpp\|h\|rb\)" | xargs ctags -a -R --fields=+lS 

pkg :
	# ruby install_rb.rb

