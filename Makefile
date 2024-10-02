##############
# parameters #
##############
# should we show commands executed ?
DO_MKDBG?=0
# do you want dependency on the Makefile itself ?
DO_ALLDEP:=1
# should we convert md to pdf?
DO_PDF:=1
# do you want to run mdl on md files?
DO_MD_MDL:=1
# do you want to run markdownlint on md files?
DO_MD_MARKDOWNLINT:=1

########
# code #
########
MD_SRC:=$(shell find src -type f -and -name "*.md")
MD_BAS:=$(basename $(MD_SRC))
MD_PDF:=$(addprefix out/,$(addsuffix .pdf,$(basename $(MD_SRC))))
MD_MDL:=$(addprefix out/,$(addsuffix .mdl,$(MD_BAS)))
MD_MARKDOWNLINT:=$(addprefix out/,$(addsuffix .markdownlint,$(MD_BAS)))
ALL:=

ifeq ($(DO_PDF),1)
ALL+=$(MD_PDF)
endif # DO_PDF

ifeq ($(DO_MD_MDL),1)
ALL+=$(MD_MDL)
endif # DO_MD_MDL

ifeq ($(DO_MD_MARKDOWNLINT),1)
ALL+=$(MD_MARKDOWNLINT)
endif # DO_MD_MARKDOWNLINT

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

.PHONY: debug
debug:
	$(info MD_SRC is $(MD_SRC))
	$(info MD_BAS is $(MD_BAS))
	$(info MD_PDF is $(MD_PDF))
	$(info MD_MDL is $(MD_MDL))
	$(info MD_MARKDOWNLINT is $(MD_MARKDOWNLINT))
	$(info ALL is $(ALL))

.PHONY: clean
clean:
	$(Q)rm $(ALL)

.PHONY: clean_hard
clean_hard:
	$(Q)git clean -qffxd

.PHONY: spell_many
spell_many:
	$(info doing [$@])
	$(Q)aspell_many.sh $(MD_SRC)

############
# patterns #
############
$(MD_PDF): out/%.pdf: %.md
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)pandoc $< -o $@
$(MD_MDL): out/%.mdl: %.md .mdlrc .mdl.style.rb
	$(info doing [$@])
	$(Q)GEM_HOME=gems gems/bin/mdl $<
	$(Q)mkdir -p $(dir $@)
	$(Q)touch $@
$(MD_MARKDOWNLINT): out/%.markdownlint: %.md .markdownlint.json
	$(info doing [$@])
	$(Q)node_modules/.bin/markdownlint -c .markdownlint.json $<
	$(Q)mkdir -p $(dir $@)
	$(Q)touch $@

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
