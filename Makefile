
# Create a new draft
# Usage: make [draft-short-name]

%::
	cp -a Tools/skel drafts/$@
	mv drafts/$@/draft-hamnaberg--00.xml drafts/$@/draft-hamnaberg-$@-00.xml
	sed -i '' -e"s/draft-hamnaberg--00/draft-hamnaberg-$@-00/" \
		drafts/$@/draft-hamnaberg-$@-00.xml
