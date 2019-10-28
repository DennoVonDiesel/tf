build/main: main.go main.yml
	test -d build || mkdir build
	GOARCH=amd64 GOOS=linux go build -o build/main main.go
	cp main.yml build/

all: build/main

clean:
	rm -rf build/
