
OUTPUT:=hell

SOURCES:=$(shell find -iname "*.hx")
PACKAGES:=-lib physaxe
HXFLAGS:=-swf-header 417:476:30:0 -swf-version 9

$(OUTPUT).swf: $(SOURCES) assets.swf
	haxe $(PACKAGES) -main Main -swf-lib assets.swf $(HXFLAGS) -swf9 $@

ASSETS:=$(shell find data)

assets.swf: $(ASSETS) resources.xml
	SamHaXe resources.xml assets.swf

run: $(OUTPUT).swf
	flashplayer $(OUTPUT).swf

clean:
	rm -rf assets.swf
