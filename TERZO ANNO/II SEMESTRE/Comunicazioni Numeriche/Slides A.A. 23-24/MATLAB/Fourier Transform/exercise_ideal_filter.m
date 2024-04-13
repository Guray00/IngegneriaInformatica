% Sampling time in seconds
tempoCampionamento = 1e-2;
% scelta filtro 'passa-basso' 'passa-banda'
filter = 'passa-basso';

switch filter

    case 'passa-basso'

        %% Generazione Filtro Passa-basso
        Banda_filtro = 1e1;% Hz
        durata_filtro = 100/Banda_filtro;

        [h_passo_basso, H_passo_basso] = generate_filtro_passa_basso(Banda_filtro,durata_filtro,tempoCampionamento);

        % Scelta filtro
        h = h_passo_basso;

    case 'passa-banda'

        %% Generazione Filtro Passa-banda
        Banda_filtro = 10;% Hz
        durata_filtro = 60/Banda_filtro;
        frequenza_centrale = 30;

        [h_passa_banda, H_passa_banda] = generate_filtro_passa_banda(Banda_filtro,durata_filtro,frequenza_centrale,...
            tempoCampionamento);

        % Scelta filtro
        h = h_passa_banda;

end