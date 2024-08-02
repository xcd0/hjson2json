BIN           := ./hjson2json
REVISION      := `git rev-parse --short HEAD`
FLAG          :=  -a -tags netgo -trimpath -ldflags='-s -w -extldflags="-static" -buildid='

all:
	cat ./makefile
build:
	@go build -o $(BIN)
release:
	rm -f $(BIN).exe $(BIN) $(BIN)_mac $(BIN)_upx.exe $(BIN)_upx $(BIN)_upx_mac
	GOOS=windows go build $(FLAG) -o $(BIN).exe
	GOOS=linux go build $(FLAG) -o $(BIN)
	GOOS=darwin go build $(FLAG) -o $(BIN)_mac
	upx --lzma $(BIN).exe -o $(BIN)_upx.exe
	upx --lzma $(BIN)     -o $(BIN)_upx
	upx --lzma $(BIN)_mac -o $(BIN)_upx_mac
	mv $(BIN)_upx.exe $(BIN).exe
	mv $(BIN)_upx     $(BIN)
	mv $(BIN)_upx_mac $(BIN)_mac
	echo Success!
test:
	make build
	./hjson2json -d ./sample.hjson
	cat ./sample.hjson | ./hjson2json -d
