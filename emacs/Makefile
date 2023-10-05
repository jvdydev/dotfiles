
RM=rm
CP=rsync -avP

install:
	$(CP) . ~/.config/emacs

clean:
	$(RM) -rf $(shell git ls-files -i --exclude-standard -o --directory)
