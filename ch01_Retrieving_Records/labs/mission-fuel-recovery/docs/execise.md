## 1. Cenário: Projeto "Fuel & Recovery"

A empresa de logística onde trabalhamos teve uma falha catastrófica nos sensores de telemetria da frota de caminhões. Recebemos um despejo bruto de dados na tabela `truck_telemetry`.
**O Problema:** O Diretor de Operações precisa de uma lista imediata dos **5 caminhões com maior risco de parada**.
O "Risco" é calculado pela soma da `fuel_level` (combustível) e `battery_voltage`.
**O Caos nos Dados:** * Muitos sensores falharam e enviaram valores **NULL** para o combustível ou bateria.
- Se um valor for NULL, o sistema deve assumir o "pior cenário" para segurança: **0 para combustível** e **10 para bateria**.
- A tabela tem 150 colunas de telemetria inútil (temperatura da cabine, cor do painel, etc.), mas nosso link de satélite está operando a **2kbps**.

---

## 2. As Restrições do Sistema (O "Nó" na Engenharia)

Para garantir que você aplique a teoria pura e não use "açúcar sintático" de ferramentas modernas:

1. **Proibido o uso de `SELECT *`:** Se o seu código tiver um asterisco, o sistema de satélite (simulado) derruba a conexão por excesso de carga. Você deve projetar apenas as colunas essenciais: `truck_id`, a métrica calculada de risco e o status.
2. **Referência Obrigatória por Alias:** Você **deve** criar um alias chamado `critical_score` para o cálculo de risco. A restrição severa é: você é obrigado a filtrar no `WHERE` apenas caminhões cujo `critical_score` seja menor que 20.
    - _Nota do Tech Lead:_ Você sabe que o SQL padrão não permite filtrar aliases no `WHERE` diretamente. Você deve resolver isso usando a estrutura de **Inline View (Subquery no FROM)** que discutimos.

---

## 3. O Critério de Aceite (Definition of Done)

Para eu assinar o seu _pull request_, o seu terminal deve cuspir um relatório SQL com exatamente estas características:

- **Apenas 3 colunas:** `ID`, `SCORE` e `SITUATION` (Uma coluna `CASE` que diga 'ALERTA' se score < 15 e 'MONITORAR' caso contrário).
- **Exatamente 5 linhas:** Nem mais, nem menos.
- **Determinismo Total:** Se eu rodar o script 10 vezes, os 5 caminhões devem ser rigorosamente os mesmos e na mesma ordem (do menor score para o maior).
- **Tratamento de NULL:** Nenhum valor `NULL` pode aparecer no cálculo; o `COALESCE` deve ter transformado o "vazio" nos valores de contingência (0 e 10).

---

## 4. O Check-point Acadêmico

1. **Sobre a Ordem de Execução:** Por que, tecnicamente, o banco de dados daria um erro se você tentasse colocar o `WHERE critical_score < 20` diretamente na consulta principal, sem usar uma subquery?
2. **Sobre o Não-Determinismo:** Se você removesse a cláusula `ORDER BY`, mas mantivesse o `LIMIT 5` (ou `TOP 5`), por que esse resultado seria considerado "lixo computacional" para uma auditoria de segurança?

---
