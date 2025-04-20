
run :
	ruby main.rb

all : main.rb
	ruby cv.rb

~/ts : main.rb
	ruby cv.rb --make
	@sleep 3
	@echo
	@echo output ::
	ls -al main.rb
	@echo run 
	@echo	ruby main.rb
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

