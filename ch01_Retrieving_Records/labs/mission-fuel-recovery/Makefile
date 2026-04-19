DB_NAME=mission_recovery
DB_USER=techlead
DB_CONTAINER=logistics_db
OUTPUT_DIR=output

.PHONY: all setup run test clean audit

all: setup run test

setup:
	@echo "🚀 Levantando a infraestrutura..."
	docker compose up -d
	@echo "⏳ Aguardando o banco de dados ficar pronto..."
	@until docker exec $(DB_CONTAINER) pg_isready -U $(DB_USER) -d $(DB_NAME); do \
		sleep 1; \
	done
	@echo "✅ Banco de dados online."

run:
	@mkdir -p $(OUTPUT_DIR)
	@echo "📡 Executando a missão e gerando output..."
	docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME) -t -A < scripts/03_solution.sql > $(OUTPUT_DIR)/run_$(shell date +%s).log
	@cp $(OUTPUT_DIR)/run_$(shell date +%s).log $(OUTPUT_DIR)/latest.log

test:
	@echo "🔬 Verificando determinismo..."
	@docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME) -t -A < scripts/03_solution.sql > $(OUTPUT_DIR)/test_run.log
	@if diff $(OUTPUT_DIR)/latest.log $(OUTPUT_DIR)/test_run.log > /dev/null; then \
		echo "✅ DETERMINISMO VALIDADO: As saídas são idênticas."; \
	else \
		echo "❌ FALHA: O sistema produziu resultados divergentes!"; \
		diff $(OUTPUT_DIR)/latest.log $(OUTPUT_DIR)/test_run.log; \
		exit 1; \
	fi

clean:
	@echo "🧹 Destruindo laboratório e limpando logs..."
	docker compose down -v
	rm -rf $(OUTPUT_DIR)/*.log