##############
# parameters #
##############
# should we show commands executed ?
DO_MKDBG?=0
# should we convert md to pdf?
DO_PDF=1
# do you want to do tools?
DO_TOOLS:=1

########
# code #
########
FILES_MD=$(shell find src -name "*.md")
FILES_PDF=$(addprefix out/,$(addsuffix .pdf,$(basename $(FILES_MD))))
TOOLS=tools.stamp
ALL:=

# tools
ifeq ($(DO_TOOLS),1)
.EXTRA_PREREQS+=$(TOOLS)
ALL+=$(TOOLS)
endif # DO_TOOLS

ifeq ($(DO_PDF),1)
ALL+=$(FILES_PDF)
endif # DO_PDF

ifeq ($(DO_MKDBG),1)
Q=
# we are not silent in this branch
else # DO_MKDBG
Q=@
#.SILENT:
endif # DO_MKDBG

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

$(TOOLS): packages.txt config/deps.py
	$(info doing $@)
	$(Q)xargs -a packages.txt sudo apt-get -y install
	$(Q)touch $@

.PHONY: debug
debug:
	$(info FILES_MD is $(FILES_MD))
	$(info FILES_PDF is $(FILES_PDF))
	$(info ALL is $(ALL))

.PHONY: clean
clean:
	$(Q)rm $(ALL)

.PHONY: clean_hard
clean_hard:
	$(Q)git clean -qffxd

############
# patterns #
############
$(FILES_PDF): out/%.pdf: %.md
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)pandoc $< -o $@
