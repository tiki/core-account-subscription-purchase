.PHONY: compile build delete clean

compile: src/state_machine.json $(wildcard src/states/*.json)
	mkdir -p out
	set -x; \
    jq -s '.[0] as $$base | .[1:] | reduce .[] as $$state ($$base; .States += $$state)' $^ > out/state_machine.json
	cd infra/step_function && sam validate --lint

build:
	cd infra/step_function && sam build $(flags)

package:
	cd infra/step_function && sam package $(flags)

deploy:
	cd infra/step_function && sam deploy $(flags)

delete:
	cd infra/step_function && sam delete $(flags)

clean:
	rm -rf out
	rm -rf infra/step_function/.aws-sam
