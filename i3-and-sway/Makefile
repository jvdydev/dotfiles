
RM=rm
CP=rsync -avP
MKDIR=mkdir -p

WM ?= sway
VARIANT ?= native

all:
	@echo "Run 'make install' to install sway config"
	@echo "Run 'make install WM=i3' to install i3 config"
	@echo ""
	@echo "To install for WSL, also provide 'VARIANT=wsl'"

install: install-wm-config install-scripts

install-wm-config:
	$(MKDIR) ~/.config/$(WM)
	$(CP) ./config/config_base ~/.config/$(WM)
	$(CP) ./config/config_$(VARIANT) ~/.config/$(WM)/config

install-scripts:
	$(MKDIR) ~/.local/bin
	$(CP) ./scripts/* ~/.local/bin
