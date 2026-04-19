## 🏁 LAB DEBRIEF: MISSION FUEL & RECOVERY

### 1. CONCLUSÃO (BLUF)
O motor de detecção de anomalias foi implementado com sucesso, garantindo que 100% dos caminhões com falha de sensor (NULL) sejam tratados como prioridade máxima através de um Score de Risco calculado em tempo real.

### 2. ARGUMENTOS TÉCNICOS (A Lógica)
* **Resiliência a NULL:** O uso de `COALESCE` nas colunas `fuel` e `battery` garantiu que o cálculo do score (`SCORE`) nunca resulte em `NULL`, evitando "pontos cegos" na frota.
* **Isolamento de Lógica:** A aplicação de uma **Inline View** permitiu filtrar o `critical_score` sem expor a complexidade do cálculo na camada de projeção final.
* **Determinismo:** A ordenação por `SITUATION` e `ID` garante que o satélite receba exatamente os mesmos dados em caso de retransmissão.

### 3. O APRENDIZADO DA TRINCHEIRA
* **Erro de Sintaxe:** Identificada a importância da vírgula como delimitador de projeção no `SELECT` e a ordem estrita de execução (onde o `WHERE` não enxerga aliases).
* **Automação:** O `Makefile` provou ser essencial para garantir que o banco de dados esteja realmente pronto (`pg_isready`) antes da execução da query.

### 4. HOW TO REPRODUCE
1.  **Prerequisites:** Certifique-se de ter `docker`, `docker-compose` e `make` instalados (Ambiente Linux/WSL2 recomendado).
2.  **Deployment:** Execute `make setup`. O sistema irá levantar o banco PostgreSQL e aguardar o (`pg_isready`) antes de liberar o terminal.
3.  **Execution:** Execute `make run`. A query de extração será disparada contra o pântano de dados e o resultado será salvo em `output/`.
4.  **Audit:** Execute `make test`. O motor irá realizar uma segunda corrida e comparar os *hashes* dos arquivos para garantir que o sistema é 100% determinístico.
5.  **Clean Up:** Execute `make clean` para destruir o laboratório e não deixar lixo processual no seu hardware.
