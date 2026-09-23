-- Registra a origem de cada solicitação sem alterar os dados existentes.
ALTER TABLE "solicitacoes"
  ADD COLUMN "id_departamento_solicitante" INTEGER,
  ADD COLUMN "solicitado_por" INTEGER;

-- As solicitações já existentes foram originadas no departamento do ticket.
UPDATE "solicitacoes" AS solicitacao
SET "id_departamento_solicitante" = ticket."id_departamento"
FROM "tickets" AS ticket
WHERE ticket."id" = solicitacao."id_ticket";

ALTER TABLE "solicitacoes"
  ALTER COLUMN "id_departamento_solicitante" SET NOT NULL;

CREATE INDEX "solicitacoes_id_departamento_solicitante_idx"
  ON "solicitacoes"("id_departamento_solicitante");

CREATE INDEX "solicitacoes_solicitado_por_idx"
  ON "solicitacoes"("solicitado_por");

ALTER TABLE "solicitacoes"
  ADD CONSTRAINT "solicitacoes_id_departamento_solicitante_fkey"
  FOREIGN KEY ("id_departamento_solicitante") REFERENCES "departamentos"("id")
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "solicitacoes"
  ADD CONSTRAINT "solicitacoes_solicitado_por_fkey"
  FOREIGN KEY ("solicitado_por") REFERENCES "usuarios"("id")
  ON DELETE SET NULL ON UPDATE CASCADE;
