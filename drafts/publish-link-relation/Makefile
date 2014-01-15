# Base directory for I-D
ID_BASE = ../..

saxpath = "$(ID_BASE)/Tools/.lib/saxon.jar"
dt="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")"
saxon = java -jar $(saxpath) -now:$(dt) -l
stylesheet = "$(ID_BASE)/Tools/rfc2629xslt/rfc2629.xslt"
xml2rfc = "/usr/local/bin/xml2rfc"
rfc2629dir = "..\\/..\\/Tools\\/rfc2629xslt\\/"

TITLE = hamnaberg-$(shell basename ${CURDIR})
LATEST = $(shell (ls draft-${TITLE}-*.xml || echo "draft-${TITLE}-00.xml") | sort | tail -1)
VERSION = $(shell basename ${LATEST} .xml | awk -F- '{print $$NF}')

TARGET_XML = draft-$(TITLE)-$(VERSION).xml
PREV_TXT = draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}-1 | bc`).txt
NEXT_XML = draft-$(TITLE)-$(shell printf "%.2d" `echo ${VERSION}+1 | bc`).xml

TARGET_HTML = $(TARGET_XML:.xml=.html)
TARGET_TXT = $(TARGET_XML:.xml=.txt)
TARGETS = $(TARGET_HTML) \
          $(TARGET_TXT)
CACHE = ./.refcache

.PHONY: all
all: $(TARGETS)

.PHONY: clean
clean:
	rm -f $(TARGETS) && rm -r $(CACHE)

.PHONY: next
next: 
	cp $(TARGET_XML) $(NEXT_XML)

.PHONY: diff
diff: 
	rfcdiff $(PREV_TXT) $(TARGET_TXT)

.PHONY: idnits
idnits: $(TARGET_TXT)
	idnits $<

%.html: %.xml
	$(saxon) $< $(stylesheet) > $@

%.txt: %.xml
	$(xml2rfc) -n --text $< $@

.PHONY: kramdown
kramdown: draft.md
	kramdown-rfc2629 draft.md > $(TARGET_XML)
	xmllint --format $(TARGET_XML) > tmp
	mv tmp $(TARGET_XML)
	sed -i '' -e"s/rfc2629\.xslt/$(rfc2629dir)rfc2629.xslt/" $(TARGET_XML)
	sed -i '' -e"s/rfc2629\.dtd/$(rfc2629dir)rfc2629.dtd/" $(TARGET_XML)
