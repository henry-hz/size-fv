
.PHONY: watch run clean

ver:
	@while true; do \
		inotifywait -e close_write ./src/erc20/**; \
		clear; \
		dafny verify ./src/erc20/erc20.dfy; \
	done

# compile src files to out folder
verify:
	@while true; do \
		inotifywait -e close_write ./src/**; \
		clear; \
		dafny verify ./src/libs/*.dfy; \
	done

v1:
	while inotifywait -e close_write ./util/**; do clear; dafny verify ./src/util/*.dfy; done

# compile src files to out folder
compile:
	while inotifywait -e close_write ./*; do clear; dafny build ./src/main.dfy -o ./out/main.dll; done


build:
	dafny build ./src/${f}.dfy -o ./out/${f}

test:
	dafny test ${f} -o ./out/${f}



watch:
	while inotifywait -e close_write ./src/*.dfy; do clear; $(MAKE) run; done


run:
	@echo "[INFO] $(shell date '+%Y-%m-%d %H:%M:%S') Running Dafny file..."
	@dafny run --no-verify ./src/libs/math.dfy
	@$(MAKE) clean

clean:
	@echo "[INFO] $(shell date '+%Y-%m-%d %H:%M:%S') Cleaning up..."
	@rm -f ./src/*.dll ./src/*.runtimeconfig.json
	@rm -f ./src/*/*.dll ./src/*/*.runtimeconfig.json
	@echo "[INFO] $(shell date '+%Y-%m-%d %H:%M:%S') Cleanup complete."
