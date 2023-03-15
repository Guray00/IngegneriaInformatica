<?php

namespace laureandosi;

class LaureandoInformatica extends Laureando
{
    public function __construct(int $matricola, string $cdl, \DateTime $data_laurea)
    {
        parent::__construct($matricola, $cdl, $data_laurea);
        $esame_bonus = $this->getEsameBonus();
        if (!is_null($esame_bonus)) {
            $esame_bonus->in_avg = false;
        }
    }

    /**
     * Restituisce la media pesata dei voti degli esami informatici
     * @return float
     */
    public function getMediaPesataInINF(): float
    {
        return round(array_reduce($this->esami, function ($acc, $esame) {
            return $acc + $esame->voto * $esame->cfu * $esame->in_inf;
        }, 0) / array_reduce($this->esami, function ($acc, $esame) {
            return $acc + $esame->cfu * $esame->in_inf;
        }, 0), 3);
    }

    /**
     * Restituisce true se il laureando ha diritto al bonus
     * @return bool
     */
    public function getBonusINF(): bool
    {
        $data_limite = date_create($this->anno_immatricolazione + 4 . "-03-31");
        return !date_diff($this->data_laurea, $data_limite)->invert;
    }

    /**
     * Restituisce l'esame bonus
     * @return Esame|null
     */
    private function getEsameBonus(): ?Esame
    {
        if (!$this->getBonusINF()) {
            return null;
        }

        return array_reduce($this->esami, function &($acc, &$esame) {
            if (
                (is_null($acc) ||
                $acc->voto > $esame->voto ||
                ($acc->voto == $esame->voto && $acc->cfu < $esame->cfu)) &&
                $esame->in_avg
            ) {
                return $esame;
            } else {
                return $acc;
            }
        });
    }
}
