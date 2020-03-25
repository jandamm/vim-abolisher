build:
	swift build -Xswiftc -suppress-warnings -c release
	\cp -rf .build/release/abolisher bin/abolisher
install: build
	\cp -rf bin/abolisher /usr/local/bin
uninstall:
	\[ -x /usr/local/bin/abolisher ] && rm /usr/local/bin/abolisher || true
test:
	swift test -Xswiftc -suppress-warnings | xcpretty -c
