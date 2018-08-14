# Install boyter/scc, "a very fast accurate code counter with complexity calculations"
go install github.com/boyter/scc
mv $GOPATH/bin/scc /usr/local/bin/

# Install cespare/reflex to "Run a command when files change"
go get github.com/cespare/reflex
